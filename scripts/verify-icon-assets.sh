#!/usr/bin/env bash
set -euo pipefail

source_svg="assets/brand/espacial-mark.svg"
macos_icon="assets/icons/macos/Espacial.icns"

required_files=(
  "$source_svg"
  "$macos_icon"
  "assets/icons/linux/ai.sofik.espacial.svg"
  "assets/icons/linux/ai.sofik.espacial.desktop"
  "assets/icons/web/favicon.svg"
  "assets/icons/web/favicon.ico"
  "assets/icons/web/site.webmanifest"
)

for size in 16 32 48 64 128 256 512; do
  required_files+=("assets/icons/linux/ai.sofik.espacial-${size}.png")
done

for file in "${required_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "error: missing or empty icon asset: $file" >&2
    exit 1
  fi
done

if ! cmp -s "$source_svg" "assets/icons/linux/ai.sofik.espacial.svg"; then
  echo "error: Linux scalable icon differs from the canonical brand SVG" >&2
  exit 1
fi

if ! cmp -s "$source_svg" "assets/icons/web/favicon.svg"; then
  echo "error: web SVG favicon differs from the canonical brand SVG" >&2
  exit 1
fi

check_png_dimensions() {
  local file="$1"
  local expected="$2"
  if ! file "$file" | grep -Fq "PNG image data, ${expected} x ${expected}"; then
    echo "error: $file is not a ${expected}x${expected} PNG" >&2
    exit 1
  fi
  if ! file "$file" | grep -Fq "RGBA"; then
    echo "error: $file must preserve alpha transparency" >&2
    exit 1
  fi
}

for size in 16 32 48 64 128 256 512; do
  check_png_dimensions "assets/icons/linux/ai.sofik.espacial-${size}.png" "$size"
done

check_png_dimensions "assets/icons/web/favicon-16x16.png" 16
check_png_dimensions "assets/icons/web/favicon-32x32.png" 32
check_png_dimensions "assets/icons/web/apple-touch-icon.png" 180
check_png_dimensions "assets/icons/web/icon-192.png" 192
check_png_dimensions "assets/icons/web/icon-512.png" 512

if [[ "$(file -b "$macos_icon")" != *"Mac OS X icon"* ]]; then
  echo "error: $macos_icon is not an ICNS file" >&2
  exit 1
fi

if ! grep -Fq '<key>CFBundleIconFile</key>' scripts/package-macos-app.sh; then
  echo "error: macOS package does not declare CFBundleIconFile" >&2
  exit 1
fi

if ! grep -Fq 'share/icons/hicolor' scripts/package-release.sh; then
  echo "error: Linux package does not install hicolor icons" >&2
  exit 1
fi

echo "application icon assets verified"
