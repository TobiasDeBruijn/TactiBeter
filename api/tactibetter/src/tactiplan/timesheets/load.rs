use std::collections::HashMap;
use chrono::NaiveDateTime;
use chrono_tz::Tz;
use const_format::concatcp;
use crate::tactiplan::{CLIENT, date_string_to_epoch, TACTI_BASE, TactiError, TactiResult, time_string_to_epoch};
use serde::{Deserialize, Serialize};
use tap::TapFallible;
use tracing::warn;

pub struct Timesheet {
    /// Available departments
    pub departments: Vec<NamedId>,
    /// Available task groups
    pub task_groups: Vec<NamedId>,
    /// Additional note
    pub note_text: Option<String>,
    /// Timesheet block
    pub blocks: Vec<TimesheetBlock>,
}

pub struct TimesheetBlock {
    /// The date of the block.
    /// Set at 00:00 on the day
    pub date: i64,
    /// Unix epoch timestamp at which the block begins
    pub begin: i64,
    /// The Unix epoch timestamp at which the block ends
    pub end: i64,
    /// The department ID
    pub department: String,
    /// The task ID
    pub task: String,
    /// Whether the time block has been submitted for approval
    pub submitted: bool,
    /// Whether the submission is approved, can only be true if `submitted` is true.
    pub approved: bool,
}

pub struct NamedId {
    pub id: String,
    pub name: String,
}

#[derive(Debug, Deserialize)]
struct Response {
    data: ResponseData,
}

#[derive(Debug, Deserialize)]
struct ResponseData {
    form_data: FormData,
}

#[derive(Debug, Clone, Deserialize)]
struct FormData {
    block_fields: Vec<BlockField>,
    scheduled_blocks: Vec<ScheduledBlock>,
    submitted_blocks: Vec<ScheduledBlock>,
    approved_blocks: Vec<ScheduledBlock>,
    note: Note,
}

#[derive(Debug, Clone, Deserialize)]
struct Note {
    text: String,
}

#[derive(Debug, Clone, Deserialize)]
struct ScheduledBlock {
    date: String,
    begin: String,
    end: String,
    department_id: String,
    task_group_id: String,
}

#[derive(Debug, Clone, Deserialize)]
struct BlockField {
    id: String,
    items: Vec<BlockItem>
}

#[derive(Debug, Clone, Deserialize)]
struct BlockItem {
    id: String,
    name: String,
}

#[derive(Debug, Serialize)]
struct RequestJson<'a> {
    date: &'a str,
    token: &'a str,
    transaction: &'a str,
}

#[derive(Debug, Serialize)]
struct RequestForm<'a> {
    data: String,
    e: &'a str,
}

const TIMESHEET_LOAD_URL: &str = concatcp!(TACTI_BASE, "/app/urencontrole_opgeven/load");

pub async fn load(phpsessid: &str, token: &str, date: i64) -> TactiResult<Timesheet> {
    let n_datetime = NaiveDateTime::from_timestamp(date, 0);
    let datetime_utc = n_datetime.and_local_timezone(Tz::UTC).unwrap();
    let datetime_ams = datetime_utc.with_timezone(&Tz::Europe__Amsterdam);

    let date = format!("{} 00:00:00", datetime_ams.format("%Y-%m-%d"));
    let data_payload = serde_json::to_string(&RequestJson {
        date: &date,
        token,
        transaction: ""
    })?;

    let response = CLIENT.post(TIMESHEET_LOAD_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .form(&RequestForm {
            data: data_payload,
            e: "1"
        })
        .send()
        .await?
        .error_for_status()?
        .text()
        .await?;

    let response: Response = serde_json::from_str(&response)
        .tap_err(|e| warn!("Unable to deserialize response payload: {e}. Payload was: {response}"))?;

    let departments = response.data.form_data.block_fields
        .clone()
        .into_iter()
        .filter(|x| x.id.eq("department_id"))
        .collect::<Vec<_>>()
        .remove(0)
        .items
        .into_iter()
        .map(|x| NamedId {
            id: x.id,
            name: x.name
        })
        .collect::<Vec<_>>();

    let task_groups = response.data.form_data.block_fields
        .clone()
        .into_iter()
        .filter(|x| x.id.eq("task_group_id"))
        .collect::<Vec<_>>()
        .remove(0)
        .items
        .into_iter()
        .map(|x| NamedId {
            id: x.id,
            name: x.name
        })
        .collect::<Vec<_>>();

    let scheduled = response.data.form_data.scheduled_blocks
        .into_iter()
        .map(TimesheetBlock::try_from)
        .collect::<TactiResult<Vec<_>>>()?;

    let submitted = response.data.form_data.submitted_blocks
        .into_iter()
        .map(TimesheetBlock::try_from)
        .collect::<TactiResult<Vec<_>>>()?;

    let mut joined = scheduled.into_iter()
        .map(|x| ((x.begin, x.end), x))
        .collect::<HashMap<(_, _), _>>();

    submitted.into_iter()
        .for_each(|mut submitted| {
            joined.entry((submitted.begin, submitted.end))
                .and_modify(|x| x.submitted = true)
                .or_insert({
                    submitted.submitted = true;
                    submitted
                });
        });

    let approved = response.data.form_data.approved_blocks
        .into_iter()
        .map(TimesheetBlock::try_from)
        .collect::<TactiResult<Vec<_>>>()?;

    approved.into_iter()
        .for_each(|mut approved| {
            joined.entry((approved.begin, approved.end))
                .and_modify(|x| x.approved = true)
                .or_insert({
                    approved.approved = true;
                    approved
                });
        });

    let timesheet = Timesheet {
        departments,
        task_groups,
        note_text: (!response.data.form_data.note.text
            .is_empty())
            .then(|| response.data.form_data.note.text),
        blocks: joined.into_iter().map(|(_, x)| x).collect::<Vec<_>>(),
    };

    Ok(timesheet)
}

impl TryFrom<ScheduledBlock> for TimesheetBlock {
    type Error = TactiError;
    fn try_from(x: ScheduledBlock) -> Result<Self, Self::Error> {
        Ok(TimesheetBlock {
            date: date_string_to_epoch(&x.date)?,
            begin: time_string_to_epoch(&x.begin)?,
            end: time_string_to_epoch(&x.end)?,
            department: x.department_id,
            task: x.task_group_id,
            submitted: false,
            approved: false,
        })
    }
}
