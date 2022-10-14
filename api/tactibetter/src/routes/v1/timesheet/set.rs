use crate::routes::empty::Empty;
use crate::routes::error::WebResult;
use crate::routes::session::Session;
use crate::WebData;

pub async fn set(_: WebData, _: Session) -> WebResult<Empty> {
    Ok(Empty)
}
