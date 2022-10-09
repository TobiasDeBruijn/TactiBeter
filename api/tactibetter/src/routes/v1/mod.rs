use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::routes::Routable;

mod login;
mod schedule;

pub struct Router;

impl Routable for Router {
    fn configure(config: &mut ServiceConfig) {
        config.service(web::scope("/v1")
            .route("/login", web::post().to(login::login))
            .route("/schedule", web::get().to(schedule::get))
        );
    }
}