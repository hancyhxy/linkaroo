#!/usr/bin/env bash
# Render docs/branding/logo.svg → 1024×1024 PNG and drop it into the
# iOS AppIcon asset catalog. Xcode auto-generates all smaller idiom
# sizes from this single 1024 universal slot — no need to ship 13
# legacy size files.
#
# Prereq: brew install librsvg
#
# Usage: ./scripts/render-icon.sh

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
src="$repo_root/docs/branding/logo.svg"
appicon_set="$repo_root/AussieBridgeApp/Assets.xcassets/AppIcon.appiconset"
out="$appicon_set/icon-1024.png"

if [ ! -f "$src" ]; then
    echo "✗ Source SVG not found: $src" >&2
    exit 1
fi

if ! command -v rsvg-convert >/dev/null 2>&1; then
    echo "✗ rsvg-convert not installed."                  >&2
    echo "  Install with: brew install librsvg"           >&2
    exit 1
fi

mkdir -p "$appicon_set"

rsvg-convert \
    --width 1024 \
    --height 1024 \
    --output "$out" \
    "$src"

echo "✓ Rendered: $out"
echo "  Now open AussieBridgeApp/AussieBridge.xcodeproj and verify the AppIcon shows in Assets.xcassets."
