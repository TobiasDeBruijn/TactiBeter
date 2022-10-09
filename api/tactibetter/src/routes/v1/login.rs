use actix_multiresponse::Payload;
use proto::{LoginRequest, LoginResponse};
use crate::routes::error::{WebError, WebResult};
use crate::WebData;
use crate::dal::user::User;

pub async fn login(data: WebData, payload: Payload<LoginRequest>) -> WebResult<Payload<LoginResponse>> {
    let existing_user = User::get_by_name(&data.pool, &data.config.encryption_key, &payload.username)?;
    let user = if let Some(user) = existing_user {
        if payload.password.eq(&user.password) {
            crate::tactiplan::login::login(&user.name, &user.password).await?;
            user
        } else {
            return Err(WebError::InvalidCredentials);
        }
    } else {
        crate::tactiplan::login::login(&payload.username, &payload.password).await?;
        User::add_user(&data.pool, &data.config.encryption_key, &payload.username, &payload.password)?
    };

    let (id, exp) = user.create_session(&data.pool)?;
    Ok(Payload(LoginResponse {
        sessionid: id,
        expires_at: exp,
    }))
}
