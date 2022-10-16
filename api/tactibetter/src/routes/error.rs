use actix_web::http::StatusCode;
use actix_web::ResponseError;
use thiserror::Error;
use crate::tactiplan::TactiError;

pub type WebResult<T> = Result<T, WebError>;

#[derive(Debug, Error)]
pub enum WebError {
    #[error("Invalid credentials")]
    InvalidCredentials,
    #[error("{0}")]
    Tacti(TactiError),
    #[error("{0}")]
    Dal(#[from] crate::dal::DalError),
    #[error("Unauthorized")]
    Unauthorized,
    #[error("Bad request")]
    BadRequest
}

impl From<TactiError> for WebError {
    fn from(x: TactiError) -> Self {
        match x {
            TactiError::InvalidCredentials => Self::InvalidCredentials,
            _ => Self::Tacti(x)
        }
    }
}

impl ResponseError for WebError {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::Unauthorized => StatusCode::UNAUTHORIZED,
            Self::InvalidCredentials => StatusCode::UNAUTHORIZED,
            Self::Tacti(_) => StatusCode::FAILED_DEPENDENCY,
            Self::Dal(_) => StatusCode::INTERNAL_SERVER_ERROR,
            Self::BadRequest => StatusCode::BAD_REQUEST,
        }
    }
}