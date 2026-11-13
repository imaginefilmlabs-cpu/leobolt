# LeoBolt — AI Film Studio

Website for [leobolt.in](https://leobolt.in): AI films, narramatics, animated videos and AI VFX.
Hosted on GitHub Pages from the `main` branch. Every push to `main` goes live in about a minute.

## What's where

| Path | What it is |
|---|---|
| `index.html` | The whole site: layout, styles, interactions |
| `clips.json` | **The video wall**: every clip, its label, category, camcorder stamp, India flag, in display order |
| `films/` | Full-length Earlier Work films (720p, with sound), played in the viewer on click |
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

**Add an Earlier Work film** (pre-AI work: loop on the wall, full film with sound on click)
1. `tools/add_film.sh e03 <video-url-or-file> <loop-start-seconds>` → makes `wall/e03.mp4` + `.webp` (4 s loop) and `films/e03.mp4` (full film)
2. Add to `clips.json`: `{"id": "e03", "label": "Brand — Film", "category": "earlier", "stamp": "TVC", "india": true, "full": "films/e03.mp4"}`
3. `python3 tools/build.py`

**Remove or reorder clips** — delete or move entries in `clips.json`, then `python3 tools/build.py`.

**Replace a clip** — `tools/add_clip.sh c05 <new-video>` (same id), then `python3 tools/build.py`.

**Text, email, colours, logo** — edit `index.html` directly (contact email: search `leoboltstudio@gmail.com`).

**Check before going live** — `node tools/check.js /tmp` screenshots desktop + phone and reports script errors.

**Go live** — `git add -A && git commit -m "…" && git push`.

Categories: `film` · `music` · `product` · `anim` · `vfx` · `narra` · `earlier`. Clips are 480p, ~4 s, no audio.
Product clips must show only **YOUR BRAND** — never a real brand's name or logo.
