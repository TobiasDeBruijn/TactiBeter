use mysql::{params, Pool, Row};
use mysql::prelude::Queryable;
use rand::Rng;
use crate::dal::DalResult;

pub struct User {
    pub name: String,
    pub password: String,
}

const SESSION_VALID_SECS: i64 = 2_592_000; // 30 days

impl User {
    pub fn add_user<S: AsRef<str>, S1: AsRef<str>>(pool: &Pool, encryption_key: &str, name: S, password: S1) -> DalResult<Self> {
        let mut conn = pool.get_conn()?;

        let encrypted = crate::dal::encryption::encrypt(encryption_key.as_bytes(), password.as_ref().as_bytes())?;

        conn.exec_drop("INSERT INTO users (name, nonce, cipher) VALUES (:name, :nonce, :cipher)", params! {
            "name" => name.as_ref(),
            "nonce" => encrypted.nonce,
            "cipher" => encrypted.ciphertext
        })?;

        Ok(Self {
            name: name.as_ref().to_string(),
            password: password.as_ref().to_string(),
        })
    }

    pub fn get_by_name<S: AsRef<str>>(pool: &Pool, encryption_key: &str, name: S) -> DalResult<Option<Self>> {
        let mut conn = pool.get_conn()?;
        let row: Row = match conn.exec_first("SELECT nonce, cipher FROM users WHERE name = :name", params! {
            "name" => name.as_ref()
        })? {
            Some(x) => x,
            None => return Ok(None)
        };

        let nonce: Vec<u8> = row.get("nonce").unwrap();
        let cipher: Vec<u8> = row.get("cipher").unwrap();
        let password = String::from_utf8(crate::dal::encryption::decrypt(encryption_key.as_bytes(), &nonce, &cipher)?)?;

        Ok(Some(Self {
            name: name.as_ref().to_string(),
            password
        }))
    }

    pub fn get_by_session<S: AsRef<str>>(pool: &Pool, encryiption_key: &str, session_id: S) -> DalResult<Option<Self>> {
        let mut conn = pool.get_conn()?;
        let row: Row = match conn.exec_first("SELECT name,expiry FROM sessions WHERE id = :id", params! {
            "id" => session_id.as_ref(),
        })? {
            Some(x) => x,
            None => return Ok(None)
        };

        let name: String = row.get("name").unwrap();
        let expiry: i64 = row.get("expiry").unwrap();

        if time::OffsetDateTime::now_utc().unix_timestamp() > expiry {
            conn.exec_drop("DELETE FROM sessions WHERE id = :id", params! {
                "id" => session_id.as_ref(),
            })?;

            return Ok(None)
        }

        Self::get_by_name(&pool, encryiption_key, name)
    }

    pub fn create_session(&self, pool: &Pool) -> DalResult<(String, i64)> {
        let mut conn = pool.get_conn()?;

        let id = rand::thread_rng().sample_iter(rand::distributions::Alphanumeric).take(32).map(char::from).collect::<String>();
        let exp: i64 = time::OffsetDateTime::now_utc().unix_timestamp() + SESSION_VALID_SECS;

        conn.exec_drop("INSERT INTO sessions (id, name, expiry) VALUES (:id, :name, :expiry)", params! {
            "id" => &id,
            "name" => &self.name,
            "expiry" => exp
        })?;

        Ok((id, exp))
    }

    pub fn reset_session_expiry<S: AsRef<str>>(&self, pool: &Pool, session_id: S) -> DalResult<i64> {
        let mut conn = pool.get_conn()?;
        let exp: i64 = time::OffsetDateTime::now_utc().unix_timestamp() + SESSION_VALID_SECS;

        conn.exec_drop("UPDATE sessions SET expiry = :expiry WHERE id = :id", params! {
            "id" => session_id.as_ref(),
            "expiry" => exp
        })?;

        Ok(exp)
    }

    pub fn update_password<S: AsRef<str>>(&mut self, pool: &Pool, encryption_key: &str, new_password: S) -> DalResult<()> {
        let mut conn = pool.get_conn()?;
        let encrypted = crate::dal::encryption::encrypt(encryption_key.as_bytes(), new_password.as_ref().as_bytes())?;

        conn.exec_drop("UPDATE users SET nonce = :nonce, cipher = :cipher WHERE name = :name", params! {
            "name" => &self.name,
            "cipher" => &encrypted.ciphertext,
            "nonce" => &encrypted.nonce
        })?;
        self.password = new_password.as_ref().to_string();

        Ok(())
    }
}