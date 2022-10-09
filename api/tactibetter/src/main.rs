use std::io;
use std::process::exit;
use actix_web::{App, HttpServer};
use tracing::{error, info};
use tracing_subscriber::{EnvFilter, fmt};
use tracing_subscriber::layer::SubscriberExt;
use crate::config::Config;
use crate::dal::init_dal;
use crate::routes::Routable;
use crate::webdata::{AppData, WebData};

mod tactiplan;
mod routes;
mod webdata;
mod config;
mod dal;

#[actix_web::main]
async fn main() -> io::Result<()> {
    setup_tracing();

    info!("Starting TactiBetter v{}", env!("CARGO_PKG_VERSION"));

    let config: Config = envy::from_env().expect("Unable to parse configuration");
    if config.encryption_key.as_bytes().len() != 32 {
        error!("Encryption key must be exactly 32 bytes");
        exit(1);
    }

    let pool = init_dal(&config).expect("Unable to initialize DAL");

    let webdata = WebData::new(AppData {
        pool,
        config
    });

    HttpServer::new(move || App::new()
        .wrap(actix_cors::Cors::permissive())
        .wrap(tracing_actix_web::TracingLogger::default())
        .app_data(webdata.clone())
        .configure(routes::Router::configure)
    )
    .bind("0.0.0.0:8080")?
    .run()
    .await
}

fn setup_tracing() {
    if std::env::var("RUST_LOG").is_err() {
        std::env::set_var("RUST_LOG", "INFO");
    }

    let sub = tracing_subscriber::registry()
        .with(fmt::layer().compact())
        .with(EnvFilter::from_env("RUST_LOG"));
    tracing::subscriber::set_global_default(sub).expect("Setting subscriber");
}
