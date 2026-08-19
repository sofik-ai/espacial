#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 6 ]]; then
  echo "usage: $0 BINARY_DIR OUTPUT_DIR VERSION PLATFORM FORMAT SIGNING_STATE" >&2
  exit 2
fi

binary_directory="$1"
output_directory="$2"
version="$3"
platform="$4"
archive_format="$5"
signing_state="$6"

if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: version must be vMAJOR.MINOR.PATCH" >&2
  exit 1
fi

for binary in espacial-server espacial-desktop; do
  if [[ ! -f "$binary_directory/$binary" ]]; then
    echo "error: missing release binary $binary" >&2
    exit 1
  fi
done

mkdir -p "$output_directory"
output_directory="$(cd "$output_directory" && pwd)"
staging_directory="$(mktemp -d "${TMPDIR:-/tmp}/espacial-package.XXXXXX")"
trap '/bin/rm -rf "$staging_directory"' EXIT
package_root="$staging_directory/espacial"
mkdir -p "$package_root"
cp "$binary_directory/espacial-server" "$package_root/"
cp "$binary_directory/espacial-desktop" "$package_root/"
chmod 755 "$package_root/espacial-server"
chmod 755 "$package_root/espacial-desktop"

{
  printf 'version=%s\n' "$version"
  printf 'platform=%s\n' "$platform"
  printf 'commit=%s\n' "${GITHUB_SHA:-local}"
  printf 'signing=%s\n' "$signing_state"
} > "$package_root/BUILD-INFO.txt"

archive_base="espacial-${version}-${platform}"
case "$archive_format" in
  tar.gz)
    COPYFILE_DISABLE=1 tar -C "$staging_directory" -czf "$output_directory/${archive_base}.tar.gz" espacial
    ;;
  zip)
    if command -v ditto >/dev/null; then
      COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr --keepParent "$package_root" "$output_directory/${archive_base}.zip"
    else
      (
        cd "$staging_directory"
        zip -qr "$output_directory/${archive_base}.zip" espacial
      )
    fi
    ;;
  *)
    echo "error: format must be tar.gz or zip" >&2
    exit 1
    ;;
esac

./scripts/checksum-release-assets.sh "$output_directory"
