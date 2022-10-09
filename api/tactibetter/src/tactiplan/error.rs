use thiserror::Error;
use crate::tactiplan::reqwest_xml::ReqwestXmlError;

pub type TactiResult<T> = Result<T, TactiError>;

#[derive(Debug, Error)]
pub enum TactiError {
    #[error("{0}")]
    Reqwest(#[from] reqwest::Error),
    #[error("Invalid credentials")]
    InvalidCredentials,
    #[error("Received unexpected response")]
    UnexpectedResponse,
    #[error("{0}")]
    XmlDe(fast_xml::DeError),
    #[error("{0}")]
    TimeComponentRange(#[from] time::error::ComponentRange),
    #[error("Unexpected value: {0}")]
    UnexpectedValue(String),
    #[error("{0}")]
    TimeZone(#[from] tz::error::TimeZoneError),
    #[error("{0}")]
    FindLocalTime(#[from] tz::error::FindLocalTimeTypeError),
    #[error("{0}")]
    Json(#[from] serde_json::Error),
}

impl From<ReqwestXmlError> for TactiError {
    fn from(x: ReqwestXmlError) -> Self {
        match x {
            ReqwestXmlError::Reqwest(e) => Self::Reqwest(e),
            ReqwestXmlError::Fastxml(e) => Self::XmlDe(e),
        }
    }
}