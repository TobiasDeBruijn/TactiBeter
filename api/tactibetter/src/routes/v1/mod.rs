use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::routes::Routable;

mod login;
mod schedule;
mod session;
mod timesheet;

pub struct Router;

impl Routable for Router {
    fn configure(config: &mut ServiceConfig) {
        config.service(web::scope("/v1")
            .configure(timesheet::Router::configure)
            .route("/login", web::post().to(login::login))
            .route("/schedule", web::get().to(schedule::get))
            .route("/session", web::post().to(session::session))
        );
    }
}