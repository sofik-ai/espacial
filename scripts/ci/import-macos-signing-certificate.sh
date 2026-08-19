#!/usr/bin/env bash
set -euo pipefail

if [[ "${CI:-}" != true || "${RUNNER_OS:-}" != macOS || -z "${RUNNER_TEMP:-}" || -z "${GITHUB_ENV:-}" ]]; then
  echo "error: this script only runs on a macOS CI runner" >&2
  exit 1
fi

: "${MACOS_CERTIFICATE_P12:?missing certificate}"
: "${MACOS_CERTIFICATE_PASSWORD:?missing certificate password}"
: "${MACOS_SIGNING_IDENTITY:?missing signing identity}"

certificate_path="$RUNNER_TEMP/espacial-signing.p12"
keychain_path="$RUNNER_TEMP/espacial-signing.keychain-db"
search_list_path="$RUNNER_TEMP/espacial-original-keychains.txt"
keychain_password="$(openssl rand -hex 32)"

printf '%s' "$MACOS_CERTIFICATE_P12" | /usr/bin/base64 -D > "$certificate_path"
security create-keychain -p "$keychain_password" "$keychain_path"
security set-keychain-settings -lut 21600 "$keychain_path"
security unlock-keychain -p "$keychain_password" "$keychain_path"
security import "$certificate_path" -k "$keychain_path" -P "$MACOS_CERTIFICATE_PASSWORD" -T /usr/bin/codesign >/dev/null
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$keychain_password" "$keychain_path" >/dev/null

if ! security find-identity -v -p codesigning "$keychain_path" 2>/dev/null | grep -Fq "$MACOS_SIGNING_IDENTITY"; then
  echo "error: configured Developer ID identity was not imported" >&2
  exit 1
fi

security list-keychains -d user | sed -e 's/^[[:space:]]*//' -e 's/^"//' -e 's/"$//' > "$search_list_path"
existing_keychains=()
while IFS= read -r existing_keychain; do
  if [[ -n "$existing_keychain" ]]; then
    existing_keychains+=("$existing_keychain")
  fi
done < "$search_list_path"
security list-keychains -d user -s "$keychain_path" "${existing_keychains[@]}"

echo "ESPACIAL_SIGNING_KEYCHAIN=$keychain_path" >> "$GITHUB_ENV"
/bin/rm -f "$certificate_path"
