#!/usr/bin/env bash
set -euo pipefail

if [[ "${CI:-}" != true || "${RUNNER_OS:-}" != macOS || -z "${RUNNER_TEMP:-}" || -z "${GITHUB_OUTPUT:-}" ]]; then
  echo "error: this script only runs on a macOS CI runner" >&2
  exit 1
fi

: "${MACOS_NOTARY_PRIVATE_KEY:?missing notary private key}"
: "${MACOS_NOTARY_KEY_ID:?missing notary key ID}"
: "${MACOS_NOTARY_ISSUER_ID:?missing notary issuer ID}"

archives=(secured-assets/*-signed.zip)
if [[ ${#archives[@]} -ne 1 || ! -f "${archives[0]}" ]]; then
  echo "error: expected exactly one signed macOS archive" >&2
  exit 1
fi

private_key_path="$RUNNER_TEMP/espacial-notary-key.p8"
printf '%s' "$MACOS_NOTARY_PRIVATE_KEY" | /usr/bin/base64 -D > "$private_key_path"

if ! xcrun notarytool submit "${archives[0]}" \
  --key "$private_key_path" \
  --key-id "$MACOS_NOTARY_KEY_ID" \
  --issuer "$MACOS_NOTARY_ISSUER_ID" \
  --wait >/dev/null; then
  echo "error: Apple notarization did not accept the archive" >&2
  exit 1
fi

notarized_asset="${archives[0]%-signed.zip}-notarized.zip"
mv "${archives[0]}" "$notarized_asset"
{
  echo "notarized=true"
  echo "asset=$notarized_asset"
} >> "$GITHUB_OUTPUT"
