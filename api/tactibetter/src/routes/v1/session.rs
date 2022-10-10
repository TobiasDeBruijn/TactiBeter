use actix_multiresponse::Payload;
use crate::routes::error::WebResult;
use crate::routes::session::Session;
use crate::WebData;
use proto::GetSessionResponse;

pub async fn session(data: WebData, session: Session) -> WebResult<Payload<GetSessionResponse>> {
    let exp = session.reset_session_expiry(&data.pool, &session.id)?;
    Ok(Payload(GetSessionResponse {
        expiry: exp,
    }))
}
