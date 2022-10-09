use thiserror::Error;

pub type DalResult<T> = Result<T, DalError>;

#[derive(Debug, Error)]
pub enum DalError {
    #[error("{0}")]
    Mysql(#[from] mysql::Error),
    #[error("Failed to encrypt")]
    ChaCha20Poly1305,
    #[error("{0}")]
    FromUtf8(#[from] std::string::FromUtf8Error),
}