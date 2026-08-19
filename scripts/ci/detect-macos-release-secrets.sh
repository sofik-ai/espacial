#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${GITHUB_OUTPUT:-}" ]]; then
  echo "error: GITHUB_OUTPUT is required" >&2
  exit 1
fi

signing_ready=false
notarization_ready=false

if [[ -n "${MACOS_CERTIFICATE_P12:-}" && -n "${MACOS_CERTIFICATE_PASSWORD:-}" && -n "${MACOS_SIGNING_IDENTITY:-}" ]]; then
  signing_ready=true
fi

if [[ "$signing_ready" == true && -n "${MACOS_NOTARY_PRIVATE_KEY:-}" && -n "${MACOS_NOTARY_KEY_ID:-}" && -n "${MACOS_NOTARY_ISSUER_ID:-}" ]]; then
  notarization_ready=true
fi

{
  echo "signing_ready=${signing_ready}"
  echo "notarization_ready=${notarization_ready}"
} >> "$GITHUB_OUTPUT"
