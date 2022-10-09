#![allow(clippy::derive_partial_eq_without_eq)]

mod items {
    include!(concat!(env!("OUT_DIR"), "/dev.array21.tactibetter.rs"));
}

pub use items::*;