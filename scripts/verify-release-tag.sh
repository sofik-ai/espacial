#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 vMAJOR.MINOR.PATCH" >&2
  exit 2
fi

release_tag="$1"
workspace_version="$(awk -F '"' '/^version = "/ { print $2; exit }' Cargo.toml)"

if [[ -z "$workspace_version" ]]; then
  echo "error: workspace version not found" >&2
  exit 1
fi

if [[ "$release_tag" != "v${workspace_version}" ]]; then
  echo "error: tag must match workspace version v${workspace_version}" >&2
  exit 1
fi

echo "release tag matches workspace version"
