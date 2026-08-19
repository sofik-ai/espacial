#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || "${CI:-}" != true || "${RUNNER_OS:-}" != macOS || -z "${GITHUB_OUTPUT:-}" ]]; then
  echo "error: usage requires a macOS CI runner and a release tag" >&2
  exit 2
fi

: "${ESPACIAL_SIGNING_KEYCHAIN:?missing ephemeral keychain}"
: "${MACOS_SIGNING_IDENTITY:?missing signing identity}"

version="$1"
archives=(unsigned-input/*.zip)
if [[ ${#archives[@]} -ne 1 || ! -f "${archives[0]}" ]]; then
  echo "error: expected exactly one unsigned macOS archive" >&2
  exit 1
fi

mkdir -p signed-work secured-assets
ditto -x -k --norsrc --noextattr "${archives[0]}" signed-work

app_bundle="signed-work/Espacial.app"
server_binary="$app_bundle/Contents/Helpers/espacial-server"
if [[ ! -d "$app_bundle" || ! -f "$server_binary" ]]; then
  echo "error: unsigned archive does not contain the expected app bundle" >&2
  exit 1
fi

sed -i '' 's/^signing=.*/signing=developer-id/' "$app_bundle/Contents/Resources/BUILD-INFO.txt"
codesign --force --options runtime --timestamp --keychain "$ESPACIAL_SIGNING_KEYCHAIN" --sign "$MACOS_SIGNING_IDENTITY" "$server_binary"
codesign --force --options runtime --timestamp --keychain "$ESPACIAL_SIGNING_KEYCHAIN" --sign "$MACOS_SIGNING_IDENTITY" "$app_bundle"
codesign --verify --deep --strict --verbose=0 "$app_bundle"

bundle_identifier="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app_bundle/Contents/Info.plist")"
if [[ "$bundle_identifier" != "ai.sofik.espacial" ]]; then
  echo "error: unexpected macOS bundle identifier" >&2
  exit 1
fi

asset="secured-assets/espacial-${version}-macos-arm64-signed.zip"
COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr --keepParent "$app_bundle" "$asset"

{
  echo "signed=true"
  echo "asset=$asset"
} >> "$GITHUB_OUTPUT"
