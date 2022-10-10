use std::future::Future;
use std::ops::Deref;
use std::pin::Pin;
use actix_web::{FromRequest, HttpRequest};
use actix_web::dev::Payload;
use crate::dal::user::User;
use crate::routes::error::WebError;
use crate::WebData;

pub struct Session {
    pub user: User,
    pub id: String,
}

impl Deref for Session {
    type Target = User;

    fn deref(&self) -> &Self::Target {
        &self.user
    }
}

impl FromRequest for Session {
    type Error = WebError;
    type Future = Pin<Box<dyn Future<Output = Result<Self, Self::Error>>>>;

    fn from_request(req: &HttpRequest, _: &mut Payload) -> Self::Future {
        let req = req.clone();
        Box::pin(async move {
            let authorization = req.headers()
                .get("authorization")
                .ok_or(WebError::Unauthorized)?
                .to_str()
                .map_err(|_| WebError::Unauthorized)?;

            let data: &WebData = req.app_data().unwrap();
            let user = User::get_by_session(&data.pool, &data.config.encryption_key, authorization)?
                .ok_or(WebError::Unauthorized)?;

            Ok(Self {
                user,
                id: authorization.to_string(),
            })
        })
    }
}