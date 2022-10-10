mod v1;
mod error;
mod routable;
mod session;

use actix_web::web;
use actix_web::web::ServiceConfig;
pub use routable::*;

pub struct Router;

impl Routable for Router {
    fn configure(config: &mut ServiceConfig) {
        config.service(web::scope("/api")
            .configure(v1::Router::configure)
        );
    }
}