use crate::tactiplan::{CLIENT, get_php_sessid, TACTI_BASE, TactiError, TactiResult};
use serde::Deserialize;
use const_format::concatcp;
use lazy_static::lazy_static;
use regex::Regex;
use tracing::instrument;

lazy_static! {
    static ref JWT_REGEX: Regex = Regex::new(r#"new Slick\.Sender\(\)\.init\(Tp\.urls\['Authentication'\] \+ '/logged_in', "(.*)", ""\);"#).unwrap();
}

const INDEX_URL: &str = concatcp!(TACTI_BASE, "/app/index");

#[instrument]
pub async fn get_jwt(phpsessid: &str) -> TactiResult<String> {
    let response = CLIENT.get(INDEX_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .header("Referer", "https://www.tactiplan.nl/inloggen")
        .header("Accept-Language", "en-US")
        .header("Sec-Fetch-Dest", "document")
        .header("Sec-Fetch-Mode", "navigate")
        .header("Sec-Fetch-Site", "same-origin")
        .header("Sec-Fetch-User", "?1")
        .send()
        .await?
        .error_for_status()?;

    let html = response.text().await?;
    let matches = match JWT_REGEX.captures(&html) {
        Some(x) => x,
        None => return Err(TactiError::UnexpectedResponse)
    };

    let jwt_token = match matches.get(1) {
        Some(x) => x,
        None => return Err(TactiError::UnexpectedResponse)
    }.as_str().to_string();

    Ok(jwt_token)
}
