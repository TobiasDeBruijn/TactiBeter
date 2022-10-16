use chrono::{NaiveDate, NaiveTime};
use lazy_static::lazy_static;
use regex::Regex;
use reqwest::Response;
use time::{Date, Month, PrimitiveDateTime, Time, UtcOffset};
use tracing::{instrument, warn};
use tz::LocalTimeType;
use serde::Serialize;

pub mod login;
pub mod schedule;
pub mod app_index;
pub mod timesheets;

mod reqwest_xml;
mod error;

pub use error::*;

pub const TACTI_BASE: &str = "https://www.tactiplan.nl";

lazy_static! {
    static ref CLIENT: reqwest::Client = reqwest::Client::builder()
        .cookie_store(true)
        .user_agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.53")
        .build()
        .unwrap();

    static ref JWT_REGEX: Regex = Regex::new(r#"new Slick\.Sender\(\)\.init\(Tp\.urls\['Authentication'\] \+ '/logged_in', "(.*)", ""\);"#).unwrap();
}

#[derive(Debug, Serialize)]
struct RequestForm<'a> {
    pub data: &'a str,
    pub e: &'a str,
}

#[macro_export]
macro_rules! index_or_error {
    ($input:expr,$split:expr, $idx:expr) => {
        {
            use std::str::FromStr;

            let str_val = $split.get($idx).ok_or(TactiError::UnexpectedValue(format!("Invalid datetime string '{}'", $input)))?;
            i32::from_str(str_val).map_err(|_| TactiError::UnexpectedValue(format!("Invalid datetime string component: '{}'", $input)))?
        }
    }
}

fn time_string_to_epoch(input: &str) -> TactiResult<i64> {
    // Left = date; Right = time
    let input_components = input.split(" ").collect::<Vec<&str>>();
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

fn date_string_to_epoch(date: &str) -> TactiResult<i64> {
    let split = date.split("-").collect::<Vec<_>>();
    let year = index_or_error!(date, split, 0);
    let month = index_or_error!(date, split, 1);
    let date = index_or_error!(date, split, 2);

    let n_date = NaiveDate::from_ymd(year, month as u32, date as u32);
    let n_datetime = n_date.and_time(NaiveTime::from_hms(0, 0, 0));
    let n_datetime_eur_ams = n_datetime.and_local_timezone(chrono_tz::Europe::Amsterdam).unwrap();

    Ok(n_datetime_eur_ams.timestamp())
}

#[instrument(skip_all)]
fn get_php_sessid(response: &Response) -> TactiResult<String> {
    let mut phpsessid_values = response.cookies()
        .filter(|x| x.name().eq("PHPSESSID"))
        .map(|x| x.value().to_string())
        .collect::<Vec<_>>();

    if phpsessid_values.is_empty() {
        warn!("Unexpected: Got no PHPSESSID cookie");
        return Err(TactiError::UnexpectedResponse);
    }

    let phpsessid = phpsessid_values.remove(0);
    Ok(phpsessid)
}