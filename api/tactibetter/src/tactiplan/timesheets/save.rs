use chrono::{Datelike, Timelike, Utc};
use chrono_tz::Tz::Europe__Amsterdam;
use const_format::concatcp;
use crate::tactiplan::{CLIENT, JWT_REGEX, RequestForm, TACTI_BASE, TactiError, TactiResult};
use crate::tactiplan::timesheets::{load, TactiNote, TactiScheduledBlock, TimesheetBlock};
use serde::{Serialize, Deserialize};
use tracing::{debug, instrument, warn};

#[derive(Debug)]
pub struct TimesheetSave {
    pub blocks: Vec<TimesheetBlock>,
    pub note: Option<String>,
}

#[derive(Serialize)]
struct Request<'a> {
    date: &'a str,
    blocks: Vec<TactiScheduledBlock>,
    note: TactiNote,
    token: &'a str,
    transaction: &'a str,
}

#[derive(Deserialize)]
struct Response {
    success: String,
    msg: String,
}

const SAVE_URL: &str = concatcp!(TACTI_BASE, "/app/urencontrole_opgeven/save");
const SAVE_PAGE_URL: &str = concatcp!(TACTI_BASE, "/app/urencontrole_opgeven");

#[instrument]
async fn get_updated_token(phpsessid: &str, date: &str) -> TactiResult<String> {
    let url = format!("{SAVE_PAGE_URL}?d={date}");
    let response_text = CLIENT.get(url)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .send()
        .await?
        .error_for_status()?
        .text()
        .await?;

    let matches = match JWT_REGEX.captures(&response_text) {
        Some(x) => x,
        None => return Err(TactiError::UnexpectedResponse)
    };

    let jwt_token = match matches.get(1) {
        Some(x) => x,
        None => return Err(TactiError::UnexpectedResponse)
    }.as_str().to_string();

    Ok(jwt_token)
}

#[instrument(skip(phpsessid))]
pub async fn save(phpsessid: &str, sheet: TimesheetSave) -> TactiResult<()> {
    let date = sheet.blocks.get(0).unwrap().date;

    let date_str = epoch_to_date_string(date);
    let mut date_str_split = date_str
        .split(" ")
        .collect::<Vec<_>>();
    let date_component = date_str_split.remove(0);
    let form_date = format!("{date_component} 00:00:00");

    // We need to fake load the page first
    // Without this we get an error
    let token = get_updated_token(phpsessid, &format!("{date_component}+00:00:00")).await?;
    // Which means also loading the data
    load::load(phpsessid, &token, date).await?;

    // Convert internal format to Tactiplan format
    let tacti_blocks = sheet.blocks.into_iter()
        .map(|block| TactiScheduledBlock {
            date: epoch_to_date_string(block.date).split(" ").collect::<Vec<_>>().remove(0).to_string(),
            begin: epoch_to_date_string(block.begin),
            end: epoch_to_date_string(block.end),
            department_id: block.department,
            task_group_id: block.task,
        })
        .collect::<Vec<_>>();

    debug!("Saving timesheet!: {tacti_blocks:?}");

    // Serialize data payload
    let data = serde_json::to_string(&Request {
        date: &form_date,
        blocks: tacti_blocks,
        transaction: "",
        token: &token,
        note: TactiNote {
            text: sheet.note.unwrap_or(String::default()),
        }
    })?;

    debug!(data);

    // Finally, send the request
    let response: Response = CLIENT.post(SAVE_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .form(&RequestForm {
            data: &data,
            e: "1",
        })
        .send()
        .await?
        .error_for_status()?
        .json()
        .await?;

    debug!("Done: {}", response.success);

    if response.success.ne("success") {
        warn!("Unexpected response: {}", response.msg);
        debug!("Sent payload: {}", &data);

        return Err(TactiError::UnexpectedResponse);
    }


    Ok(())
}

fn epoch_to_date_string(epoch: i64) -> String {
    let n_dt_now = chrono::NaiveDateTime::from_timestamp(epoch, 0);
    let dt_utc = n_dt_now.and_local_timezone(Utc).unwrap();
    let dt_ams = dt_utc.with_timezone(&Europe__Amsterdam);

    format!("{}-{:02}-{:02} {:02}:{:02}:{:02}",
        dt_ams.year(),
        dt_ams.month(),
        dt_ams.day(),
        dt_ams.hour(),
        dt_ams.minute(),
        dt_ams.second(),
    )
}