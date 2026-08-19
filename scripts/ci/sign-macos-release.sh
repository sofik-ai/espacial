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

for binary in signed-work/espacial/espacial-server signed-work/espacial/espacial-desktop; do
  codesign --force --options runtime --timestamp --keychain "$ESPACIAL_SIGNING_KEYCHAIN" --sign "$MACOS_SIGNING_IDENTITY" "$binary"
  codesign --verify --strict --verbose=0 "$binary"
done

printf 'signing=developer-id\n' >> signed-work/espacial/BUILD-INFO.txt
asset="secured-assets/espacial-${version}-macos-arm64-signed.zip"
COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr --keepParent signed-work/espacial "$asset"

{
  echo "signed=true"
  echo "asset=$asset"
} >> "$GITHUB_OUTPUT"
