//! Espacial background server composition root.
//!
//! Networking is intentionally absent from the foundation milestone.

use espacial_application::HealthService;
use espacial_domain::InstanceId;
use espacial_infrastructure::SystemClock;
use std::error::Error;
use uuid::Uuid;

fn main() -> Result<(), Box<dyn Error>> {
    let service = HealthService::new(SystemClock, InstanceId::from_uuid(Uuid::new_v4()));
    let output = serde_json::to_string(&service.server_info())?;
    println!("{output}");
    Ok(())
}
