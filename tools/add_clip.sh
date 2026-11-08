#!/bin/bash
# Add or replace one wall clip from a video URL or local file.
# Usage: tools/add_clip.sh <id> <url-or-path>
# Makes wall/<id>.mp4 (480p, muted, fast-start) and wall/<id>.webp (poster).
# Then add/edit the entry in clips.json and run: python3 tools/build.py
set -euo pipefail
cd "$(dirname "$0")/.."
id="$1"; src="$2"; tmp="$(mktemp -d)"
if [[ "$src" == http* ]]; then curl -sSfL -o "$tmp/in.mp4" "$src"; else cp "$src" "$tmp/in.mp4"; fi
ffmpeg -v error -y -i "$tmp/in.mp4" -vf "scale='if(gt(iw,ih),-2,480)':'if(gt(iw,ih),480,-2)'" \
  -c:v libx264 -crf 28 -preset medium -pix_fmt yuv420p -movflags +faststart -an "wall/$id.mp4"
ffmpeg -v error -y -ss 0.05 -i "$tmp/in.mp4" -frames:v 1 -vf "scale=560:-2" "wall/$id.webp"
rm -rf "$tmp"
echo "wall/$id.mp4 $(du -h "wall/$id.mp4" | cut -f1)  wall/$id.webp"
