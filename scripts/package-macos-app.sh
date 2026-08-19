#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 BINARY_DIR OUTPUT_DIR VERSION SIGNING_STATE" >&2
  exit 2
fi

binary_directory="$1"
output_directory="$2"
version="$3"
signing_state="$4"
bundle_identifier="ai.sofik.espacial"

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
staging_directory="$(mktemp -d "${TMPDIR:-/tmp}/espacial-macos.XXXXXX")"
trap '/bin/rm -rf "$staging_directory"' EXIT
app_root="$staging_directory/Espacial.app"
mkdir -p "$app_root/Contents/Helpers" "$app_root/Contents/MacOS" "$app_root/Contents/Resources"

cp "$binary_directory/espacial-desktop" "$app_root/Contents/MacOS/espacial-desktop"
cp "$binary_directory/espacial-server" "$app_root/Contents/Helpers/espacial-server"
chmod 755 "$app_root/Contents/MacOS/espacial-desktop" "$app_root/Contents/Helpers/espacial-server"

cat > "$app_root/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDisplayName</key>
  <string>Espacial</string>
  <key>CFBundleExecutable</key>
  <string>espacial-desktop</string>
  <key>CFBundleIdentifier</key>
  <string>${bundle_identifier}</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Espacial</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>${version#v}</string>
  <key>CFBundleVersion</key>
  <string>${version#v}</string>
</dict>
</plist>
PLIST

{
  printf 'version=%s\n' "$version"
  printf 'platform=macos-arm64\n'
  printf 'bundle_identifier=%s\n' "$bundle_identifier"
  printf 'commit=%s\n' "${GITHUB_SHA:-local}"
  printf 'signing=%s\n' "$signing_state"
} > "$app_root/Contents/Resources/BUILD-INFO.txt"

asset="$output_directory/espacial-${version}-macos-arm64-${signing_state}.zip"
COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr --keepParent "$app_root" "$asset"
./scripts/checksum-release-assets.sh "$output_directory"
