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
app_bundle="signed-work/Espacial.app"
stapled=false
for _attempt in 1 2 3 4 5 6; do
  if xcrun stapler staple "$app_bundle" >/dev/null 2>&1; then
    stapled=true
    break
  fi
  sleep 10
done
if [[ "$stapled" != true ]]; then
  echo "error: notarization ticket could not be stapled" >&2
  exit 1
fi
xcrun stapler validate "$app_bundle" >/dev/null
spctl --assess --type execute --verbose=0 "$app_bundle"
COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr --keepParent "$app_bundle" "$notarized_asset"
/bin/rm -f "${archives[0]}"
{
  echo "notarized=true"
  echo "asset=$notarized_asset"
} >> "$GITHUB_OUTPUT"
