//! Concrete adapters for outbound application ports.

use espacial_application::Clock;
use std::time::{SystemTime, UNIX_EPOCH};

/// Wall clock backed by the host operating system.
#[derive(Clone, Copy, Debug, Default)]
pub struct SystemClock;

impl Clock for SystemClock {
    fn unix_time_ms(&self) -> u64 {
        let elapsed = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default();
        u64::try_from(elapsed.as_millis()).unwrap_or(u64::MAX)
    }
}

#[cfg(test)]
mod tests {
    use super::SystemClock;
    use espacial_application::Clock;

    #[test]
    fn system_clock_reports_a_nonzero_unix_time() {
        assert!(SystemClock.unix_time_ms() > 0);
    }
}
