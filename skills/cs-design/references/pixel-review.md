# Pixel-by-pixel review

Read before reviewing your own work or anything another role asks you to look at. Review is your strongest skill: it finds faults in what already exists. Taste scoring belongs to cs-review (TASTE), technical measurement to cs-review (MEASURE); you give a findings list, neither a score nor a PASS.

## 1. Five rules
1. **Look yourself, at full resolution.** A contact sheet gives overview. Faults show in 100 % crops and in 200-400 % nearest-neighbour crops (`scripts/sheet.sh crop`). Never trust someone else's sheet or "it's fixed".
2. **Measure, do not estimate.** Contrast on the rendered pair (`scripts/contrast.py --image`). Text size on a whole full-size frame, not on a sheet. Scale in px/mm against a known dimension. Colors against the token list.
3. **Write what the image does NOT prove:** a screenshot does not prove the page works on a real phone or in another browser; a render does not prove the scale is right; a sheet does not show motion or time; an OCR hit on grain or a drawn stroke is an artifact until you have seen 3-4 real frames; a counter that jumps on a sheet is not a bug until you see the frame.
4. **One pass, then fixes, then one confirmation.** Batch all findings, fix them in one round, confirm each point in the image (not the change log), stop. Review without an end burns budget and does not improve the work.
5. **Evidence limit.** "Seen as a 100 % crop of a PNG" is not "tested". Say exactly how you looked.

## 2. Tools
```sh
S=skills/cs-design/scripts            # adjust to where the skill is installed
bash $S/sheet.sh slides <dir>                         # carousel in order
bash $S/sheet.sh video clip.mp4 --fps 4               # max ~9 rows
bash $S/sheet.sh frame clip.mp4 1.0                   # full frame for micro text
bash $S/sheet.sh crop slide.png - 40 300 500 220 --scale 3      # edge, kerning, halo
python3 $S/contrast.py --image slide.png --fg 540,300 --bg 40,40
python3 $S/contrast.py "#DCE3EA" "#171D24" --min 4.5
```
Use the project's own token scan, reflow, accessibility and performance tools for web (e.g. 320/640 px reflow, forced-colors, prefers-contrast, 3-run performance audits).

## 3. Checklist (in order)
**A. First impression (200 px thumbnail, one second).** What is the point? One focus? Is the subject visible? Does slide 1 / the hero read without sound or context? Empty bottom or empty areas that are not deliberate air?
**B. Sequence (contact sheet).** Does the piece repeat itself? Same template as the last post? Rhythm between materials? Last surface = end card per BRAND.md? Same system, margin and folio baseline on every slide?
**C. Typography (100 %).**
- Size: >= 30 px on 1080-wide slides (24 px absolute floor for mono labels), >= 12 px on web; measure on a whole frame.
- Wrapping: no widows/orphans in titles; rag without staircase; number and unit never split (non-breaking space); long compounds break at sensible points.
- Punctuation: real ellipsis, typographic quotes, true minus sign.
- Numbers: kerning in big numbers (unit tight to the last digit), tabular numerals in counters and tables, display tracking about -0.02 to -0.045 em.
- Fonts: only the system's; no italic if the system has none; no tofu or fallback glyphs; accented letters render.
**D. Color.** Only tokens of the surface's system; accent only on its one meaning and < 10 % of the area. Contrast measured against the worst background (lightest photo area under a scrim, darkest grain). Typical faults: red text on a dark subject, text behind the subject's body, dark subject on a dark road. No banding in vignettes or scrims (look at 200 %), no halo round cut-outs, no hard gradient edge, no pure #000/#fff.
**E. Geometry.** Common left edge; spacing from one scale; gap between groups >= 2x inside a group; more space above a heading than below; lines meet where they should; hairlines (1 px at 1080 in video or JPEG) shimmer, avoid; arrows and numbers do not collide. Physics and scale: contact shadow under objects, nothing floats, direction of motion correct, product at true scale from one px/mm number. Safe zone for carousels: key content inside x 70-1010, y 110-1240 (grid crop).
**F. Image.** No soft upscaling, no JPEG blocks in flat skies; deliberate crop (subject in lower third with room ahead); privacy: consent per person, no legible plates/bibs/numbers, no route or map, EXIF stripped, no AI-generated people.
**G. Honesty.** "Illustration" label on every drawn scene; every number is in the trace table; nothing BRAND.md bans, also in file names.
**H. Web in addition.** Widths 390 and 1440, 320 without horizontal scroll, 200 % zoom; reduced motion shows the end state, not an empty section; forced-colors and prefers-contrast work; tab through everything with visible focus not hidden under a header, targets >= 44 px; no layout shift when fonts and images load; LCP element is what you think; all languages equally finished.

## 4. Report
Write `review-<object>-v<N>.md` beside the work and send the same text as the message, max 12 lines:
```
<object> v<N> · review · sha256 <8 chars> · <n> findings (P0 a, P1 b, P2 c, P3 d)
Seen: <sheet + 100 % crops of slides 1-7 | 390/1440 + 320 + reduced motion>. Not seen: <real phone, other browser, sound ...>
1 [P0] <file> <slide/selector/time> (x,y) - what is wrong - why (rule/source) - concrete fix
Send to: <owner> (top 3 first; full list in the file)
```
- **P0** blocks: honesty, consent or approval breach, unreadable text, contrast under threshold, wrong number.
- **P1** is large: wrong hierarchy or focus, wrong system or color, overlap, scale.
- **P2** small: spacing, rag, kerning. **P3** polish.
On your **own work** fix all P0 and P1 before delivering. On **others' work** send the top 3 to the owner and let them fix; you do not edit their files.
