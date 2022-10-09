use mysql::{OptsBuilder, Pool};
use thiserror::Error;
use crate::config::Config;

mod encryption;
mod error;
pub mod user;

pub use error::*;

#[derive(Debug, Error)]
pub enum InitDalError {
    #[error("{0}")]
    Refinery(#[from] refinery::Error),
    #[error("{0}")]
    Mysql(#[from] mysql::Error)
}

mod migrations {
    use refinery::embed_migrations;
    embed_migrations!("migrations");
}

pub fn init_dal(config: &Config) -> Result<Pool, InitDalError> {
    let opts = OptsBuilder::new()
        .ip_or_hostname(Some(&config.mysql_host))
        .db_name(Some(&config.mysql_database))
        .user(Some(&config.mysql_username))
        .pass(Some(&config.mysql_password));
    let pool = Pool::new(opts)?;

    let mut conn = pool.get_conn()?;
    migrations::migrations::runner()
        .set_migration_table_name("__tactibetter_migrations")
        .run(&mut conn)?;

    Ok(pool)
}
