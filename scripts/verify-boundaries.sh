#!/usr/bin/env bash
set -euo pipefail

desktop_manifest="apps/espacial-desktop/Cargo.toml"
domain_manifest="crates/espacial-domain/Cargo.toml"

if grep -Eq 'espacial-(application|domain|infrastructure|server)' "$desktop_manifest"; then
  echo "error: desktop must not depend on server internals" >&2
  exit 1
fi

if grep -Eq '^espacial-' "$domain_manifest"; then
  echo "error: domain must not depend on another Espacial crate" >&2
  exit 1
fi

echo "architecture dependency checks passed"
