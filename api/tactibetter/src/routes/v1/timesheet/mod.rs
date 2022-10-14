use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::Routable;

mod load;
mod set;

pub struct Router;

impl Routable for Router {
    fn configure(config: &mut ServiceConfig) {
        config.service(web::scope("/timesheet")
            .route("", web::get().to(load::load))
            .route("/set", web::post().to(set::set))
        );
    }
}