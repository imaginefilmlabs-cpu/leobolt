# LeoBolt — AI Film Studio

Website for [leobolt.in](https://leobolt.in): AI films, narramatics, animated videos and AI VFX.
Hosted on GitHub Pages from the `main` branch. Every push to `main` goes live in about a minute.

## What's where

| Path | What it is |
|---|---|
| `index.html` | The whole site: layout, styles, interactions |
| `clips.json` | **The video wall**: every clip, its label, category, camcorder stamp, India flag, in display order |
| `wall/` | `cNN.mp4` (480p, muted) and `cNN.webp` (poster) for each clip |
| `brand/` | Logos (white type, full, lion, wordmark), colour logo + animated sting, favicon |
| `tools/` | Scripts to add clips, rebuild the wall and check the page |
| `CNAME` | Custom domain — keep it, or leobolt.in stops working |

## Update workflow

**Add a clip**
1. `tools/add_clip.sh c59 <video-url-or-file>` → makes `wall/c59.mp4` + `wall/c59.webp`
2. Add an entry to `clips.json` where it should appear:
   `{"id": "c59", "label": "Crash Zoom", "category": "music", "stamp": "AUG.30", "india": false}`
3. `python3 tools/build.py`

**Remove or reorder clips** — delete or move entries in `clips.json`, then `python3 tools/build.py`.

**Replace a clip** — `tools/add_clip.sh c05 <new-video>` (same id), then `python3 tools/build.py`.

**Text, email, colours, logo** — edit `index.html` directly (contact email: search `hello@leobolt.in`).

**Check before going live** — `node tools/check.js /tmp` screenshots desktop + phone and reports script errors.

**Go live** — `git add -A && git commit -m "…" && git push`.

Categories: `film` · `music` · `product` · `anim` · `vfx` · `narra`. Clips are 480p, ~4 s, no audio.
Product clips must show only **YOUR BRAND** — never a real brand's name or logo.
