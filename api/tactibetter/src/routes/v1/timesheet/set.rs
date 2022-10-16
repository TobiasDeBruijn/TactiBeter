use actix_multiresponse::Payload;
use crate::routes::empty::Empty;
use crate::routes::error::{WebError, WebResult};
use crate::routes::session::Session;
use crate::tactiplan::timesheets::save::TimesheetSave;
use crate::tactiplan::timesheets::TimesheetBlock;
use tracing::instrument;

#[instrument(skip(session))]
pub async fn set(session: Session, payload: Payload<proto::SaveTimesheetRequest>) -> WebResult<Empty> {
    if payload.blocks.is_empty() {
        return Err(WebError::BadRequest);
    }

    let phpsessid = crate::tactiplan::login::login(&session.name, &session.password).await?;
    crate::tactiplan::app_index::get_jwt(&phpsessid).await?;

    crate::tactiplan::timesheets::save::save(&phpsessid, TimesheetSave {
        blocks: payload.blocks.iter()
            .map(|x| TimesheetBlock {
                date: x.date,
                begin: x.begin,
                end: x.end,
                department: x.department.clone(),
                task: x.task.clone(),
                submitted: false,
                approved: false
            })
            .collect::<Vec<_>>(),
        note: payload.note.clone(),
    }).await?;

    Ok(Empty)
}
