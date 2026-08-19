//! Application use cases and outbound ports.

use espacial_domain::InstanceId;
use espacial_protocol::{CURRENT_PROTOCOL, ServerInfo};

/// Supplies wall-clock time without coupling use cases to an operating system.
pub trait Clock: Send + Sync {
    /// Returns milliseconds elapsed since the Unix epoch.
    fn unix_time_ms(&self) -> u64;
}

/// Application service for server readiness metadata.
pub struct HealthService<C> {
    clock: C,
    instance_id: InstanceId,
}

impl<C> HealthService<C>
where
    C: Clock,
{
    /// Creates the service with its explicit outbound dependencies.
    #[must_use]
    pub const fn new(clock: C, instance_id: InstanceId) -> Self {
        Self { clock, instance_id }
    }

    /// Returns process metadata expressed as a public protocol contract.
    #[must_use]
    pub fn server_info(&self) -> ServerInfo {
        ServerInfo {
            protocol: CURRENT_PROTOCOL,
            instance_id: self.instance_id.as_hyphenated_string(),
            unix_time_ms: self.clock.unix_time_ms(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{Clock, HealthService};
    use espacial_domain::InstanceId;
    use espacial_protocol::CURRENT_PROTOCOL;
    use std::error::Error;

    struct FixedClock;

    impl Clock for FixedClock {
        fn unix_time_ms(&self) -> u64 {
            42
        }
    }

    #[test]
    fn health_uses_the_clock_and_current_contract() -> Result<(), Box<dyn Error>> {
        let id = InstanceId::parse("f7b676ba-243b-4bed-94e4-2ea5570e767b")?;
        let health = HealthService::new(FixedClock, id).server_info();

        assert_eq!(health.protocol, CURRENT_PROTOCOL);
        assert_eq!(health.unix_time_ms, 42);
        assert_eq!(health.instance_id, "f7b676ba-243b-4bed-94e4-2ea5570e767b");
        Ok(())
    }
}
