#!/usr/bin/env bash
set -euo pipefail

if [[ "${RUNNER_OS:-}" != macOS || -z "${RUNNER_TEMP:-}" ]]; then
  exit 0
fi

keychain_path="$RUNNER_TEMP/espacial-signing.keychain-db"
certificate_path="$RUNNER_TEMP/espacial-signing.p12"
private_key_path="$RUNNER_TEMP/espacial-notary-key.p8"
search_list_path="$RUNNER_TEMP/espacial-original-keychains.txt"

if [[ -f "$search_list_path" ]]; then
  original_keychains=()
  while IFS= read -r original_keychain; do
    if [[ -n "$original_keychain" ]]; then
      original_keychains+=("$original_keychain")
    fi
  done < "$search_list_path"
  if [[ ${#original_keychains[@]} -gt 0 ]]; then
    security list-keychains -d user -s "${original_keychains[@]}"
  fi
fi

case "$keychain_path" in
  "$RUNNER_TEMP"/espacial-signing.keychain-db)
    security delete-keychain "$keychain_path" >/dev/null 2>&1 || true
    ;;
  *)
    echo "error: refusing to delete unexpected keychain path" >&2
    exit 1
    ;;
esac

/bin/rm -f "$certificate_path" "$private_key_path" "$search_list_path"
