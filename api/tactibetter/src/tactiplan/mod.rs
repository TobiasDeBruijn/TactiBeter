use lazy_static::lazy_static;
use reqwest::Response;
use tracing::{instrument, warn};

pub mod login;
pub mod schedule;
pub mod app_index;

mod reqwest_xml;
mod error;

pub use error::*;

pub const TACTI_BASE: &str = "https://www.tactiplan.nl";

lazy_static! {
    static ref CLIENT: reqwest::Client = reqwest::Client::builder()
        .cookie_store(true)
        .user_agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.53")
        .build()
        .unwrap();
}

#[instrument(skip_all)]
fn get_php_sessid(response: &Response) -> TactiResult<String> {
    let mut phpsessid_values = response.cookies()
        .filter(|x| x.name().eq("PHPSESSID"))
        .map(|x| x.value().to_string())
        .collect::<Vec<_>>();

    if phpsessid_values.is_empty() {
        warn!("Unexpected: Got no PHPSESSID cookie");
        return Err(TactiError::UnexpectedResponse);
    }

    let phpsessid = phpsessid_values.remove(0);
    Ok(phpsessid)
}