#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "error: icon generation requires macOS sips and iconutil" >&2
  exit 1
fi

for tool in sips iconutil; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "error: missing required tool: $tool" >&2
    exit 1
  fi
done

source_svg="${1:-assets/brand/espacial-mark.svg}"
if [[ ! -f "$source_svg" ]]; then
  echo "error: missing source SVG: $source_svg" >&2
  exit 1
fi

macos_directory="assets/icons/macos"
linux_directory="assets/icons/linux"
web_directory="assets/icons/web"
temporary_directory="$(mktemp -d "${TMPDIR:-/tmp}/espacial-icons.XXXXXX")"
trap '/bin/rm -rf "$temporary_directory"' EXIT
iconset_directory="$temporary_directory/Espacial.iconset"

mkdir -p "$macos_directory" "$linux_directory" "$web_directory" "$iconset_directory"

render_png() {
  local size="$1"
  local destination="$2"
  sips -z "$size" "$size" -s format png "$source_svg" --out "$destination" >/dev/null
}

render_png 16 "$iconset_directory/icon_16x16.png"
render_png 32 "$iconset_directory/icon_16x16@2x.png"
render_png 32 "$iconset_directory/icon_32x32.png"
render_png 64 "$iconset_directory/icon_32x32@2x.png"
render_png 128 "$iconset_directory/icon_128x128.png"
render_png 256 "$iconset_directory/icon_128x128@2x.png"
render_png 256 "$iconset_directory/icon_256x256.png"
render_png 512 "$iconset_directory/icon_256x256@2x.png"
render_png 512 "$iconset_directory/icon_512x512.png"
render_png 1024 "$iconset_directory/icon_512x512@2x.png"
iconutil -c icns "$iconset_directory" -o "$macos_directory/Espacial.icns"

cp "$source_svg" "$linux_directory/ai.sofik.espacial.svg"
for size in 16 32 48 64 128 256 512; do
  render_png "$size" "$linux_directory/ai.sofik.espacial-${size}.png"
done

cp "$source_svg" "$web_directory/favicon.svg"
render_png 16 "$web_directory/favicon-16x16.png"
render_png 32 "$web_directory/favicon-32x32.png"
render_png 180 "$web_directory/apple-touch-icon.png"
render_png 192 "$web_directory/icon-192.png"
render_png 512 "$web_directory/icon-512.png"
sips -s format ico "$web_directory/favicon-32x32.png" --out "$web_directory/favicon.ico" >/dev/null

echo "generated Espacial icons from $source_svg"
