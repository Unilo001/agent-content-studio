# MEASURE checks

You measure; you do not score taste and do not grant exceptions. Run in order. Each row: command -> PASS / WARN / FIX -> owner. Cannot run = UNTESTABLE + reason; UNTESTABLE is never PASS. Thresholds below are defaults: BRAND.md overrides them, and the piece's brief may state agreed exceptions.

## Rules
- Measure on a copy with its sha256; if the file changes during QA, restart on a new copy. State filename, version and sha in the report.
- Measure the final muxed file. Only a silent render delivered? Run picture checks and write "sound not delivered".
- Write the report in the same turn as the last measurement. Never run the same measurement on the same hash twice.
- One heavy job at a time on the machine; check for running renders first.
- Scripts and word lists are pointers, not verdicts. A hit on meta-text or dead code is ignorable - say why.

## M0 Setup
```
mkdir -p "$Q" && cp piece.mp4 "$Q/in.mp4" && shasum -a 256 piece.mp4 "$Q/in.mp4"
ffprobe -v error -show_entries format=duration:stream=codec_type,avg_frame_rate,width,height -of compact "$Q/in.mp4"
```
Two equal hashes = OK. Check resolution/aspect against BRAND.md (default vertical 1080x1920).

## Video checks
| # | Check | Default threshold | Owner at FIX |
|---|---|---|---|
| M1 | Cheap pre-check: `python3 scripts/banned_words.py` over script/on-screen text/caption; project OCR/claims tool | zero hits that are shown or spoken | cs-animation / cs-story |
| M2 | Duration | as in the brief; outside it = WARN unless the brief agrees | cs-animation |
| M3 | Safe zone: text and key elements away from platform UI overlays | text inside the central ~75 % height and ~90 % width; right edge free near the platform buttons | cs-animation |
| M4 | Text size and contrast | sentences >= ~62 px on 1080 wide, labels >= ~40 px, contrast >= 4.5:1 | cs-animation |
| M5 | Read time per card | cs-story table; `characters / 20` s is a ceiling for captions that follow speech, not a floor; with VO <= 3 words or one number per card | cs-story |
| M6 | Flash / blink rate | <= 3 flashes per second | cs-animation |
| M7 | Dead stretches (no motion) | none >= 0.75 s (except 0.3-0.75 s before climax); frame-diff or motion script | cs-animation |
| M8 | End card | whole logo held >= 1.8 s (>= 3.2 s with a CTA), per BRAND.md | cs-animation |
| M9 | Words and claims in OCR + source text | banned words and unsupported present-tense claims = FIX | cs-story / cs-animation |
| M10 | Numbers on screen equal facts.md | exact match, same rounding and labelling | cs-animation |
| M11 | Consent and metadata: only listed people; EXIF/GPS stripped on export | per BRAND.md | cs-orchestrator |

## Audio checks (final mux)
| # | Check | Default threshold |
|---|---|---|
| A1 | Integrated loudness | target from BRAND.md (default -14 to -16 LUFS +/- 1) |
| A2 | True peak on the final encoded file | <= -1.5 dBTP target, FIX above -1.0 dBTP |
| A3 | Phone-speaker proxy: high-pass ~150 Hz, VO still intelligible, cues still audible | judgment from spectrum + silence list |
| A4 | Cue sync: cues within ~0.5 ms of the cue sheet; cue times measured from frames | per cue sheet |
| A5 | Sources: sound effects only from allowed sources in BRAND.md; licence recorded | per BRAND.md |
| A6 | Variant without music if the brief requires one | file exists |
Always write "measured, not heard".
```
ffmpeg -nostdin -hide_banner -i in.mp4 -af ebur128=peak=true -f null - 2>&1 | tail -12
```

## Website / carousel
- Link check, language parity (if bilingual), meta description length (<= 160), every URL preserved.
- Honesty scan of page copy: no "validated/accurate/ride-tested"-type claims unless true (use the banned-words script on page text).
- Accessibility (keyboard, screen reader, contrast >= 4.5:1), performance (LCP, INP, CLS) via the project's audit skills.
- UI motion: block `transition: all`, `scale(0)` entrances, ease-in on UI, UI transitions > 300 ms without reason, popovers not originating from their trigger, animating layout properties where transform suffices, missing `prefers-reduced-motion` (reduced means gentler, not none), `:hover` without a hover/fine-pointer guard. Continuous motion only with transform/opacity; never drive animation from scroll events; blur <= 8 px.
- Report as a table `Before | After | Why` with `file:line`, then Block or Approve.
- Palette, font, logo changes are never approved here: the approver decides, with preview.

## 3D asset
1. Intake numbers measured in code, not by a classifier: triangles, bounding box (metres), texture size, file size, missing UVs. Starting limits (cs-3d may set others): hero <= 20,000 triangles and <= 5 MB; background <= 8,000 and <= 2 MB; textures <= 2048 px (4096 only in close-ups); one material per logical part.
2. Turntable sheet with 8 angles plus each pose still.
3. Scale on a rendered frame against known real dimensions: error <= 3 %. glTF = metres, Y up.
4. Two seeks to the same t give identical pixels. Nothing floats (contact shadow). Hero fills >= 40 % of frame height and sits in the safe zone.
5. Provenance registered (id, source, prompt, licence, scale, polycount, status, approved-by). Unregistered = FIX.
6. No real brands, logos, text, people or numbers on generated assets.
7. Approval: the product itself and real people go to the approver with a contact sheet against a real photo; props and environments are approved here (hero >= 8, background props >= 7).
