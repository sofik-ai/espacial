#!/usr/bin/env bash
set -euo pipefail

./scripts/verify-boundaries.sh
./scripts/verify-icon-assets.sh
cargo fmt --all --check
cargo clippy --workspace --all-targets --all-features --locked -- -D warnings
cargo test --workspace --all-targets --all-features --locked
cargo doc --workspace --no-deps --locked
