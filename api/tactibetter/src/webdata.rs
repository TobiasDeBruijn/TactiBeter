use actix_web::web;
use mysql::Pool;
use crate::config::Config;

pub type WebData = web::Data<AppData>;

#[derive(Debug, Clone)]
pub struct AppData {
    pub pool: Pool,
    pub config: Config,
}
