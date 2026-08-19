//! Pure business types and invariants.
//!
//! This crate deliberately has no dependency on application, infrastructure,
//! transport, or UI concerns.

use std::{error::Error, fmt};
use uuid::Uuid;

/// Stable identity for a running server instance.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub struct InstanceId(Uuid);

impl InstanceId {
    /// Creates an instance ID from an existing UUID.
    #[must_use]
    pub const fn from_uuid(value: Uuid) -> Self {
        Self(value)
    }

    /// Parses a canonical UUID into an instance ID.
    ///
    /// # Errors
    ///
    /// Returns [`InvalidInstanceId`] when `value` is not a UUID.
    pub fn parse(value: &str) -> Result<Self, InvalidInstanceId> {
        Uuid::parse_str(value).map(Self).map_err(InvalidInstanceId)
    }

    /// Returns the canonical hyphenated representation.
    #[must_use]
    pub fn as_hyphenated_string(self) -> String {
        self.0.hyphenated().to_string()
    }
}

/// Error returned when an instance ID is invalid.
#[derive(Debug)]
pub struct InvalidInstanceId(uuid::Error);

impl fmt::Display for InvalidInstanceId {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid instance ID: {}", self.0)
    }
}

impl Error for InvalidInstanceId {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        Some(&self.0)
    }
}

#[cfg(test)]
mod tests {
    use super::InstanceId;

    #[test]
    fn accepts_a_uuid_instance_id() {
        let result = InstanceId::parse("f7b676ba-243b-4bed-94e4-2ea5570e767b");

        assert!(result.is_ok());
    }

    #[test]
    fn rejects_an_invalid_instance_id() {
        let result = InstanceId::parse("local-server");

        assert!(result.is_err());
    }
}
