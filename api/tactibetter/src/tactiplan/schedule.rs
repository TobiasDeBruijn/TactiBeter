use chrono::{Datelike, NaiveDate, NaiveDateTime, NaiveTime};
use chrono_tz::UTC;
use serde::{Serialize, Deserialize};
use crate::tactiplan::{CLIENT, get_php_sessid, TACTI_BASE, TactiError, TactiResult};
use const_format::concatcp;
use time::{Date, Duration, Month, OffsetDateTime, PrimitiveDateTime, Time, UtcOffset};
use tracing::trace;
use tz::LocalTimeType;
use tracing::instrument;

const SCHEDULE_URL: &str = concatcp!(TACTI_BASE, "/app/roosters/load");
const SCHEDULE_PAGE_URL: &str = concatcp!(TACTI_BASE, "/app/roosters");

#[derive(Debug, Serialize)]
struct FormRequest<'a> {
    data: &'a str,
    e: &'a str,
}

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
    published: String,
    blocks: Vec<Block>,
}

#[derive(Debug, Deserialize)]
struct Block {
    date: String,
    begin: String,
    end: String,
    task: String,
    department: String,
    created: String,
}

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
    let ndt = chrono::NaiveDateTime::from_timestamp(week, 0);
    let dt_utc = ndt.and_local_timezone(UTC).unwrap();
    let dt_eur_ams = dt_utc.with_timezone(&chrono_tz::Europe::Amsterdam);

    let week = format!("{}-{}-{:02} 00:00:00", dt_eur_ams.year(), dt_eur_ams.month(), dt_eur_ams.day());
    let data = serde_json::to_string(&RequestData {
        week: &week,
        token: jwt,
        transaction: "",
    })?;

    let response: Response = CLIENT.post(SCHEDULE_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .form(&FormRequest {
            data: &data,
            e: "1",
        })
        .send()
        .await?
        .error_for_status()?
        .json()
        .await?;

    trace!("{response:#?}");

    response.data.blocks.into_iter()
        .map(block_to_schedule)
        .collect::<TactiResult<Vec<_>>>()
}

macro_rules! index_or_error {
    ($input:expr,$split:expr, $idx:expr) => {
        {
            use std::str::FromStr;

            let str_val = $split.get($idx).ok_or(TactiError::UnexpectedValue(format!("Invalid datetime string '{}'", $input)))?;
            i32::from_str(str_val).map_err(|_| TactiError::UnexpectedValue(format!("Invalid datetime string component: '{}'", $input)))?
        }
    }
}

fn block_to_schedule(block: Block) -> TactiResult<Schedule> {
    let split = block.date.split("-").collect::<Vec<_>>();
    let year = index_or_error!(block.date, split, 0);
    let month = index_or_error!(block.date, split, 1);
    let date = index_or_error!(block.date, split, 2);

    let n_date = NaiveDate::from_ymd(year, month as u32, date as u32);
    let n_datetime = n_date.and_time(NaiveTime::from_hms(0, 0, 0));
    let n_datetime_eur_ams = n_datetime.and_local_timezone(chrono_tz::Europe::Amsterdam).unwrap();

    Ok(Schedule {
        date: n_datetime_eur_ams.timestamp(),
        begin: time_string_to_epoch(&block.begin)?,
        end: time_string_to_epoch(&block.end)?,
        created: time_string_to_epoch(&block.created)?,
        task: block.task,
        department: block.department,
    })
}

fn time_string_to_epoch(input: &str) -> TactiResult<i64> {
    // Left = date; Right = time
    let input_components = input.split(" ").collect::<Vec<_>>();
    let date = input_components.get(0).ok_or(TactiError::UnexpectedValue(format!("Missing date half of datetime string '{input}'")))?;
    let time = input_components.get(1).ok_or(TactiError::UnexpectedValue(format!("Missing time half of datetime string '{input}'")))?;

    let date_components = date.split("-").collect::<Vec<_>>();
    let year = index_or_error!(input, date_components, 0);
    let month = index_or_error!(input, date_components, 1);
    let day = index_or_error!(input, date_components, 2);

    let time_components = time.split(":").collect::<Vec<_>>();
    let hour = index_or_error!(input, time_components, 0);
    let minute = index_or_error!(input, time_components, 1);
    let sec = index_or_error!(input, time_components, 2);

    let dt = PrimitiveDateTime::new(
        Date::from_calendar_date(year, numeric_to_month(month)?, day as u8)?,
        Time::from_hms(hour as u8, minute as u8, sec as u8)?,
    );

    let dt_assumed_utc = dt.clone().assume_utc();

    let amsterdam = tzdb::time_zone::europe::AMSTERDAM;
    let utc_offset: &LocalTimeType = amsterdam.find_local_time_type(dt_assumed_utc.unix_timestamp())?;
    let offset_secs: i32 = utc_offset.ut_offset();

    let dt_offset = dt.assume_offset(UtcOffset::from_whole_seconds(offset_secs)?);
    Ok(dt_offset.unix_timestamp())
}

fn numeric_to_month(num: i32) -> TactiResult<Month> {
    let m = match num {
        1 => Month::January,
        2 => Month::February,
        3 => Month::March,
        4 => Month::April,
        5 => Month::May,
        6 => Month::June,
        7 => Month::July,
        8 => Month::August,
        9 => Month::September,
        10 => Month::October,
        11 => Month::November,
        12 => Month::December,
        _ => return Err(TactiError::UnexpectedValue(format!("Unexpected numeric month: {num}")))
    };

    Ok(m)
}

fn month_to_numeric(month: &Month) -> i32 {
    match month {
        Month::January => 1,
        Month::February => 2,
        Month::March => 3,
        Month::April => 4,
        Month::May => 5,
        Month::June => 6,
        Month::July => 7,
        Month::August => 8,
        Month::September => 9,
        Month::October => 10,
        Month::November => 11,
        Month::December => 12,
    }
}