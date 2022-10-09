use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    pub mysql_host: String,
    pub mysql_username: String,
    pub mysql_password: String,
    pub mysql_database: String,
    pub encryption_key: String,
}