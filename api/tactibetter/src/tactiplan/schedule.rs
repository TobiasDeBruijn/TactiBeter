use chrono::{Datelike, NaiveDateTime};
use chrono_tz::UTC;
use serde::{Serialize, Deserialize};
use crate::tactiplan::{CLIENT, date_string_to_epoch, RequestForm, TACTI_BASE, TactiResult, time_string_to_epoch};
use const_format::concatcp;
use tap::TapFallible;
use time::OffsetDateTime;
use tracing::warn;
use tracing::instrument;

const SCHEDULE_URL: &str = concatcp!(TACTI_BASE, "/app/roosters/load");

#[derive(Debug, Serialize)]
struct RequestData<'a> {
    week: &'a str,
    token: &'a str,
    transaction: &'a str,
}

#[derive(Debug, Deserialize)]
struct Response {
    data: Data,
}

#[derive(Debug, Deserialize)]
struct Data {
    //published: Published,
    blocks: Vec<Block>,
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
enum Published {
    BeenPublished(bool),
    PublishedAt(String),
}

#[derive(Debug, Deserialize)]
struct Block {
    date: String,
    begin: String,
    end: String,
    task: String,
    department: String,
    created: String,
    removed: String,
}

#[derive(Clone)]
pub struct Schedule {
    /// Unix epoch seconds of the day the event takes place
    pub date: i64,
    /// The unix epoch seconds start time
    pub begin: i64,
    /// The unix epoch seconds end time
    pub end: i64,
    pub task: String,
    pub department: String,
    /// Unix epoch seconds when the event was created
    pub created: i64,
}

#[instrument(skip(jwt))]
pub async fn get_schedule(phpsessid: &str, jwt: &str, week: i64) -> TactiResult<Vec<Schedule>> {
    let ndt = NaiveDateTime::from_timestamp(week, 0);
    let dt_utc = ndt.and_local_timezone(UTC).unwrap();
    let dt_eur_ams = dt_utc.with_timezone(&chrono_tz::Europe::Amsterdam);

    let week = format!("{}-{}-{:02} 00:00:00", dt_eur_ams.year(), dt_eur_ams.month(), dt_eur_ams.day());
    let data = serde_json::to_string(&RequestData {
        week: &week,
        token: jwt,
        transaction: "",
    })?;

    let response_text = CLIENT.post(SCHEDULE_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .form(&RequestForm {
            data: &data,
            e: "1",
        })
        .send()
        .await?
        .error_for_status()?
        .text()
        .await?;

    let response: Response = serde_json::from_str(&response_text)
        .tap_err(|e| warn!("Failed to deserialize json payload: {e}. Original body\n: {response_text}"))?;

    response.data.blocks.into_iter()
        .map(|x| {
            // If no removed date is set, the date is set to 9999-00-00
            // This is an unparsable date so we bail early with a fake date in the future
            if x.removed.starts_with("9999") {
                Ok((x, OffsetDateTime::now_utc().unix_timestamp() + 10_0000))
            } else {
                let removed=  time_string_to_epoch(&x.removed)?;
                Ok((x, removed))
            }

        })
        .collect::<TactiResult<Vec<_>>>()?
        .into_iter()
        .filter(|(_, removed)| {
            if OffsetDateTime::now_utc().unix_timestamp() > *removed {
                false
            } else {
                true
            }
        })
        .into_iter()
        .map(|(block, _)| block)
        .map(block_to_schedule)
        .collect::<TactiResult<Vec<_>>>()
}

fn block_to_schedule(block: Block) -> TactiResult<Schedule> {

    Ok(Schedule {
        date: date_string_to_epoch(&block.date)?,
        begin: time_string_to_epoch(&block.begin)?,
        end: time_string_to_epoch(&block.end)?,
        created: time_string_to_epoch(&block.created)?,
        task: block.task,
        department: block.department,
    })
}