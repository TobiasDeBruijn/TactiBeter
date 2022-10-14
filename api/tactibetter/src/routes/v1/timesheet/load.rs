use actix_multiresponse::Payload;
use actix_web::web;
use serde::Deserialize;
use crate::routes::error::WebResult;
use crate::routes::session::Session;

#[derive(Debug, Deserialize)]
pub struct Query {
    date: Option<i64>,
}

pub async fn load(session: Session, query: web::Query<Query>) -> WebResult<Payload<proto::Timesheet>> {
    let date = match query.date {
        Some(x) => x,
        None => time::OffsetDateTime::now_utc().unix_timestamp()
    };

    let phpsessid = crate::tactiplan::login::login(&session.name, &session.password).await?;
    let jwt_token = crate::tactiplan::app_index::get_jwt(&phpsessid).await?;
    let timesheet = crate::tactiplan::timesheets::load::load(&phpsessid, &jwt_token, date).await?;

    Ok(Payload(proto::Timesheet {
        departments: timesheet.departments.into_iter().map(|x| proto::NamedId { name: x.name, id: x.id }).collect(),
        task_groups: timesheet.task_groups.into_iter().map(|x| proto::NamedId { name: x.name, id: x.id }).collect(),
        note_text: timesheet.note_text,
        blocks: timesheet.blocks.into_iter().map(|x| proto::TimesheetBlock {
            date: x.date,
            begin: x.begin,
            end: x.end,
            department: x.department,
            task: x.task,
            submitted: x.submitted,
            approved: x.approved,
        }).collect()
    }))
}
