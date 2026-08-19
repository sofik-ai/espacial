//! Serializable contracts shared by Espacial clients and servers.
//!
//! Types here describe the process boundary and must not contain application
//! services or server implementation details.

use serde::{Deserialize, Serialize};

/// Current wire-contract version supported by this build.
pub const CURRENT_PROTOCOL: ProtocolVersion = ProtocolVersion { major: 1, minor: 0 };

/// Semantic version of the client-server contract.
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct ProtocolVersion {
    /// Incompatible contract generation.
    pub major: u16,
    /// Backwards-compatible feature generation.
    pub minor: u16,
}

/// Kind of process initiating a connection.
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum ClientKind {
    /// Native desktop client.
    Desktop,
}

/// Initial metadata a client will send during protocol negotiation.
#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct ClientHello {
    /// Protocol understood by the client.
    pub protocol: ProtocolVersion,
    /// Client process category.
    pub client_kind: ClientKind,
    /// Human-readable application version.
    pub client_version: String,
}

/// Minimal server information used to prove the boundary.
#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct ServerInfo {
    /// Protocol exposed by the server.
    pub protocol: ProtocolVersion,
    /// Stable identifier for this server process.
    pub instance_id: String,
    /// Server clock in milliseconds since the Unix epoch.
    pub unix_time_ms: u64,
}

#[cfg(test)]
mod tests {
    use super::{CURRENT_PROTOCOL, ClientHello, ClientKind};
    use std::error::Error;

    #[test]
    fn client_hello_round_trips_as_json() -> Result<(), Box<dyn Error>> {
        let hello = ClientHello {
            protocol: CURRENT_PROTOCOL,
            client_kind: ClientKind::Desktop,
            client_version: "0.1.0".to_owned(),
        };

        let encoded = serde_json::to_string(&hello)?;
        let decoded: ClientHello = serde_json::from_str(&encoded)?;

        assert_eq!(decoded, hello);
        Ok(())
    }
}
