#!/bin/bash
# Add one "Earlier Work" film: a short muted wall loop plus the full film with sound.
# Usage: tools/add_film.sh <id> <url-or-path> [loop-start-seconds] [loop-length-seconds]
# Makes wall/<id>.mp4 + wall/<id>.webp (loop, letterbox bars cropped) and films/<id>.mp4 (full film, 720p, sound).
# Then add the entry to clips.json with "category": "earlier" and "full": "films/<id>.mp4", and run: python3 tools/build.py
set -euo pipefail
cd "$(dirname "$0")/.."
id="$1"; src="$2"; ss="${3:-0}"; len="${4:-4}"; tmp="$(mktemp -d)"; mkdir -p films
if [[ "$src" == http* ]]; then curl -sSfL -o "$tmp/in.mp4" "$src"; else cp "$src" "$tmp/in.mp4"; fi
crop="$(ffmpeg -ss "$ss" -i "$tmp/in.mp4" -t "$len" -vf cropdetect=24:2:0 -f null - 2>&1 | grep -o 'crop=[0-9:]*' | sort | uniq -c | sort -n | tail -1 | awk '{print $2}')"
crop="${crop:-crop=iw:ih:0:0}"
# keep full width: only trim top/bottom bars
IFS=: read -r _ ch _ cy <<<"${crop#crop=}:"; crop="crop=iw:${ch}:0:${cy}"
ffmpeg -v error -y -ss "$ss" -i "$tmp/in.mp4" -t "$len" -vf "$crop,scale='if(gt(iw,ih),-2,480)':'if(gt(iw,ih),480,-2)'" \
  -c:v libx264 -crf 28 -preset medium -pix_fmt yuv420p -movflags +faststart -an "wall/$id.mp4"
ffmpeg -v error -y -ss "$ss" -i "$tmp/in.mp4" -frames:v 1 -vf "$crop,scale=560:-2" "wall/$id.webp"
ffmpeg -v error -y -i "$tmp/in.mp4" -vf "$crop,scale='min(1280,iw)':-2" \
  -c:v libx264 -crf 23 -preset slow -pix_fmt yuv420p -c:a aac -b:a 128k -movflags +faststart "films/$id.mp4"
rm -rf "$tmp"
echo "wall/$id.mp4 $(du -h "wall/$id.mp4" | cut -f1)  films/$id.mp4 $(du -h "films/$id.mp4" | cut -f1)  ($crop)"
