#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! -d "$1" ]]; then
  echo "usage: $0 ASSET_DIRECTORY" >&2
  exit 2
fi

asset_directory="$1"
found=false

for asset in "$asset_directory"/*.tar.gz "$asset_directory"/*.zip; do
  if [[ ! -f "$asset" ]]; then
    continue
  fi
  found=true
  asset_name="$(basename "$asset")"
  (
    cd "$asset_directory"
    shasum -a 256 "$asset_name" > "${asset_name}.sha256"
  )
done

if [[ "$found" != true ]]; then
  echo "error: no release archives found" >&2
  exit 1
fi
