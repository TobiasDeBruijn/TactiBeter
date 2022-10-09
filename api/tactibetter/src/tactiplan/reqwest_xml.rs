use reqwest::Response;
use async_trait::async_trait;
use serde::de::DeserializeOwned;
use thiserror::Error;
use tracing::trace;

#[derive(Debug, Error)]
pub enum ReqwestXmlError {
    #[error("{0}")]
    Reqwest(#[from] reqwest::Error),
    #[error("{0}")]
    Fastxml(#[from] fast_xml::DeError),
}

#[async_trait]
pub trait ReqwestXmlExt {
    async fn xml<T: DeserializeOwned>(self) -> Result<T, ReqwestXmlError>;
}

#[async_trait]
impl ReqwestXmlExt for Response {
    async fn xml<T: DeserializeOwned>(self) -> Result<T, ReqwestXmlError> {
        let text = self.text().await?;

        trace!("Got XML body: {text}");

        let html: T = fast_xml::de::from_str(&text)?;
        Ok(html)
    }
}