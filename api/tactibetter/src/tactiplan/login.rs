use crate::tactiplan::{get_php_sessid, TACTI_BASE, TactiError, TactiResult};
use serde::Serialize;
use const_format::concatcp;
use lazy_static::lazy_static;
use reqwest::Client;
use reqwest::redirect::Policy;
use tap::TapFallible;
use tracing::warn;
use tracing::instrument;

const AUTHENTICATE_URL: &str = concatcp!(TACTI_BASE, "/authenticate");
const LOGIN_PAGE_URL: &str = concatcp!(TACTI_BASE, "/inloggen");

lazy_static! {
    static ref LOGIN_CLIENT: Client = Client::builder()
        .cookie_store(false)
        .redirect(Policy::none())
        .user_agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.53")
        .build()
        .unwrap();
}

#[derive(Debug, Serialize)]
struct LoginRequest<'a> {
    name: &'a str,
    password: &'a str,
    mobile: u8,
}

#[instrument]
async fn get_login_cookie() -> TactiResult<String> {
    let response = LOGIN_CLIENT.get(LOGIN_PAGE_URL)
        .send()
        .await?
        .error_for_status()?;
    let phpsessid = get_php_sessid(&response)?;

    Ok(phpsessid)
}

#[instrument(skip(password))]
pub async fn login(name: &str, password: &str) -> TactiResult<String> {
    let phpsessid = get_login_cookie().await?;

    let response = LOGIN_CLIENT.post(AUTHENTICATE_URL)
        .header("Cookie", format!("PHPSESSID={phpsessid}"))
        .form(&LoginRequest {
            name,
            password,
            mobile: 0
        })
        .send()
        .await?
        .error_for_status()?;

    let location_header = response.headers()
        .get("location")
        .ok_or(TactiError::UnexpectedResponse)
        .tap_err(|_| warn!("Received unexpected response"))?
        .to_str()
        .map_err(|_| TactiError::UnexpectedResponse)
        .tap_err(|_| warn!("Received unexpected response"))?;

    match location_header {
        "https://www.tactiplan.nl/app/index" => {}
        "https://www.tactiplan.nl/inloggen" => return Err(TactiError::InvalidCredentials),
        _ => {
            warn!("Received unknown location header: {location_header}");
            return Err(TactiError::UnexpectedResponse)
        }
    }

    let phpsessid = get_php_sessid(&response)?;
    Ok(phpsessid)
}