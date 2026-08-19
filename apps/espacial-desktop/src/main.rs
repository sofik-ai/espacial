//! Espacial desktop-client composition root.
//!
//! This proof-of-boundary emits the hello contract that a future transport
//! adapter will send to either a local or remote server.

use espacial_protocol::{CURRENT_PROTOCOL, ClientHello, ClientKind};
use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    let hello = ClientHello {
        protocol: CURRENT_PROTOCOL,
        client_kind: ClientKind::Desktop,
        client_version: env!("CARGO_PKG_VERSION").to_owned(),
    };
    let output = serde_json::to_string(&hello)?;
    println!("{output}");
    Ok(())
}
