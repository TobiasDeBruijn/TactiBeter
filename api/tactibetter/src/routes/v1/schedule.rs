use std::collections::HashMap;
use actix_multiresponse::Payload;
use actix_web::web;
use chrono::{Datelike, NaiveDateTime, NaiveTime, TimeZone, Weekday};
use serde::Deserialize;
use proto::GetScheduleResponse;
use crate::routes::error::WebResult;
use crate::routes::session::Session;
use crate::tactiplan::schedule::Schedule;

#[derive(Debug, Deserialize)]
pub struct Query {
    week_number: Option<u32>,
}

pub async fn get(session: Session, query: web::Query<Query>) -> WebResult<Payload<GetScheduleResponse>> {
    let phpsessid = crate::tactiplan::login::login(&session.name, &session.password).await?;
    let jwt_token = crate::tactiplan::app_index::get_jwt(&phpsessid).await?;

    let week = if let Some(week_number) = query.week_number {
        let europe_ams = chrono_tz::Europe::Amsterdam;

        let n_dt = NaiveDateTime::from_timestamp(time::OffsetDateTime::now_utc().unix_timestamp(), 0);
        let offset = n_dt.and_local_timezone(chrono_tz::Europe::Amsterdam).unwrap();
        let current_iso_week = offset.iso_week();

        let year = if week_number < current_iso_week.week() {
            current_iso_week.year() + 1
        } else {
            current_iso_week.year()
        };

        let date = europe_ams.isoywd(year, week_number, Weekday::Mon);
        let datetime = date.and_time(NaiveTime::from_hms(0, 0, 0)).unwrap();
        datetime.timestamp()
    } else {
        let n_dt = NaiveDateTime::from_timestamp(time::OffsetDateTime::now_utc().unix_timestamp(), 0);
        let offset = n_dt.and_local_timezone(chrono_tz::Europe::Amsterdam).unwrap();

        let curr_week = offset.iso_week();
        let date = chrono_tz::Europe::Amsterdam.isoywd(curr_week.year(), curr_week.week(), Weekday::Mon);
        let datetime = date.and_time(NaiveTime::from_hms(0, 0, 0)).unwrap();
        datetime.timestamp()
    };

    let schedule = crate::tactiplan::schedule::get_schedule(&phpsessid, &jwt_token, week).await?;
    let mut day_schedules: HashMap<i64, (i64, i64, Vec<Schedule>)> = HashMap::with_capacity(schedule.len());

    for schedule in schedule.into_iter() {
        day_schedules.entry(schedule.date)
            .and_modify(|(begin, end, schedules)| {
                if schedule.begin < *begin {
                    *begin = schedule.begin
                }

                if schedule.end > *end {
                    *end = schedule.end
                }

                schedules.push(schedule.clone())
            })
            .or_insert((schedule.begin, schedule.end, vec![schedule]));
    }

    let schedule_days = day_schedules.into_iter()
        .map(|(date, (begin, end, schedules))| proto::ScheduleDay {
            date,
            begin,
            end,
            schedule_entries: schedules.into_iter()
                .map(|schedule| proto::ScheduleEntry {
                    begin: schedule.begin,
                    end: schedule.end,
                    created: schedule.created,
                    department: schedule.department,
                    task: schedule.task,
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    Ok(Payload(GetScheduleResponse {
        schedule_days
    }))
}
