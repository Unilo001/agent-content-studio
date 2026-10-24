# Carousels, stills, textures, 3D on pages

Read before planning or building a carousel, a share image or another still, or before adding texture or 3D to a page. Priority is the orchestrator's: carousels often reach far fewer people than short video, so make few and strong ones and do not move video effort here without a brief.

## 1. Folder and build
`<work>/carousel-<slug>/` holds:
- `PLAN.md` (binding): the idea in one sentence, the but/therefore chain over the slides, look (tokens of ONE system), slide by slide, caption pointer, build, QA list, posting notes.
- A build script that renders the slides (headless browser at 1080x1350, deviceScaleFactor 1, local font files via `@font-face`) to `01.html ... NN.html` and `01.png ... NN.png`. Abort if a font did not load (check `document.fonts` per family) instead of silently falling back.
- **Numbers are computed in the build** from the project's calculation source or a data file, never typed; the build throws on mismatch.
- `TRACE.md`: one row per printed number or claim, with source and calculation. cs-review (FACTS) reads it before the approver sees anything.
- A contact sheet from `scripts/sheet.sh slides`.

## 2. Composition
- **One system per carousel**, per BRAND.md. A token scan should fail on mixing.
- **Slide 1 is the hook.** It shows an event or the subject with the payoff number and reads at 200 px width (feed and profile grid). A choice looks like a choice (buttons or poll). Status wording BRAND.md requires ("in development") is on slide 1 when the product is mentioned.
- **One idea per slide**, one focus, max 14 words (one method slide may exceed). Each slide is "but" or "therefore" to the previous.
- **Last slide:** end card per BRAND.md (logo from file, never typed text) and nothing after. The CTA sits in the caption.
- **Format:** 1080x1350, 2-10 slides (typically 6-8). Margin 70-72 px. The profile grid crops 4:5 to 3:4, so keep key content inside x 70-1010, y 110-1240.
- **Text at 1080 wide:** body >= 30 px (34-46 good), mono labels >= 30 (24 absolute floor), titles 72-200, focus number >= 120, title:body scale >= 6:1 with 3-4 sizes in total. Phone test at 32 cm: nothing under 30 px.
- **Editorial restraint:** air first, then a left anchor edge with ragged-right. Remove an element before shrinking the air. Accent < 10 % and one meaning. Folio ("1 / 6"), small credits and real captions are details an editor adds and a generator does not.
- **Speed is direction:** diagonals of 3-8 degrees, objects travelling into the frame, room ahead of the subject.
- **Numbers need visual weight:** large tabular numerals with a small accent unit, or a shape/line that IS the value. Several slides on one concept change only the value, not the room. No pie charts, dual axes, grid forests, legends or default library charts. A data line is raw data joined with straight segments, no smoothing or filter.
- **Real photo first** when it exists: full-bleed or passe-partout, subject in the lower third with room ahead; text over photo is measured against the lightest pixel under the scrim (`contrast.py --image`). A photo enlarged beyond its source resolution gets soft: crop harder instead.
- **Variation:** not the same template or mechanism as the previous post. Two posts using the same mechanism (e.g. a poll) should not run back to back.

## 3. Feed is not web
Scale up, or it disappears in the feed.
| Element | Web | Feed / video at 1080 wide |
|---|---|---|
| titles | 32-48 px | 64-120 (up to 200) |
| body | 14-16 | 28-42 |
| labels | 12 | 18-24 (brand floor 24/30) |
| borders | 1 px | 2-4 px |
| padding | 16-32 | 60-140 |
| decorative opacity | 3-8 % | 12-25 %; under 10 % is invisible, so remove it |
- Muted is fine, flat is not. Each slide has one element that pulls the eye (the accent when it carries the subject). Neutrals are tinted toward the system's hue; dead gray looks undesigned.
- A light surface needs more structure than a dark one: heavier rules (2 px+), load-bearing lines, paper texture so it does not read as a blank slide.
- No linear gradient across a whole dark surface: it bands after H.264/JPEG. Use flat color, a local scrim or a radial vignette.
- Composition: at least two focal points; anchor to an edge rather than floating centered; the hero fills 60-80 % of the width; split into zones (data on one side, subject on the other) instead of stacking everything in the middle.
- Type: tighter display tracking than web (-0.02 to -0.045 em); light text on dark looks bolder, so go one weight down in body and add .05-.1 line-height; the first element shown reads as most important, so choose the order deliberately.

## 4. Honesty and privacy
- Number format and marking follow BRAND.md and FACTS. Nothing BRAND.md bans, also in sprite and file names.
- No maps, routes, coordinates, start/finish. Crop photos into the build folder and strip EXIF (a re-saved crop in PIL drops it unless you ask to keep it); camera photos can carry GPS.
- Consent is checked per person from the register in BRAND.md. No legible numbers or plates. No AI-generated people.
- Show the product at true scale; do not print its dimensions without the approver's yes.

## 5. Gates before the approver
1. Token scan: 0 FAIL, every WARN explained. 2. The project's carousel-ready check (slide count, sizes, caption present). 3. Your pixel review (`pixel-review.md`). 4. FACTS reads TRACE.md, TASTE scores the slides blind, MEASURE runs the checks. 5. cs-orchestrator puts the sheet in front of the approver; the approver accepts each post.

## 6. Other stills
| Still | Format | How |
|---|---|---|
| Share / social preview image | 1200x630 PNG | scripted from tokens; logo unchanged; rebuild when a title on it changes |
| Hero / article illustration | SVG per language | one stroke weight, one accent, drawn from the system's glyph set |
| Photo on page | `<picture>` AVIF/WebP/JPG | cs-audio-edit grades; you crop and export with width/height |
| Video cover | first frame | cs-story owns the cover text; you polish only on request |
| 3D render / turntable | PNG/WebP | order from cs-3d |

## 7. Texture (the surface's material, never decoration)
Test: if you notice the grain on a thumbnail, it is too much; if you cannot name the material (film, paper, asphalt, pen), remove it.
- Texture sits behind text (`::before`, z -1), outside the flow (`position: fixed|absolute`, `pointer-events: none`) so CLS stays 0, and is static. Off under `prefers-contrast: more`, `forced-colors` and `print`; static under reduced motion.
- Grain: SVG feTurbulence (baseFrequency .85-.9) at opacity .06-.07 for stills; vary the seed per slide (same seed everywhere looks like a dirty screen). Film grain on dark surfaces only, paper tooth on light only; do not mix materials.
- Never blend modes or grain over glyph edges or small text. Banding on big gradients is fixed with a smaller area or light grain underneath, not a stronger gradient. Measure contrast against the darkest rendered part of the surface; lower the texture alpha rather than lifting the text.
- Hand-drawn strokes: one small source of imperfection per drawing (arcs with 1-2 control points nudged < 1.5 % of radius, axes overshooting 3-6 px, endpoints not quite meeting, varying stroke width); too much is a "sketchy preset", itself a template. Draw-on animates once via `pathLength=1` and dash offset, never loops, and shows the finished stroke without JS or under reduced motion. Data is never hand-drawn; the hand makes rings, brackets, arrows and underlines around data. Decorative strokes are `aria-hidden`. Do not scale stroke glyphs beyond ~2x.

## 8. 3D on a page: climb the ladder only as far as needed
1. Still render (almost always enough). 2. Short muted `<video playsinline>` with poster (the motion is the point, the user does not steer it). 3. Image sequence / flipbook, lazy poster, frames fetched on demand. 4. Interactive Three.js only when the user steers something that carries information and 1-3 cannot do it; justify in the report and get the orchestrator's yes for the dependency.
- Weight: a 3D runtime is hundreds of KB gzipped. Never load it at page load: poster in a reserved box (`aspect-ratio`, CLS 0), load on click or IntersectionObserver with generous margin; if WebGL fails the poster stays.
- Render only on change (no endless rAF loop); stop when off-screen or tab hidden; cap pixel ratio at 2; dispose on removal. No idle auto-rotate. Reduced motion shows the poster/end state; user-driven rotation still works without easing.
- A11y: canvas has `role="img"` and a label; if steerable, `role="slider"` with arrow keys; text next to it says the same; controls >= 44 px. A new file type needs the host's allowlist and cache headers: ask the orchestrator.
- Assets from cs-3d with the `web` role: budget around <= 15k triangles, <= 1.5 MB, textures <= 1024, no decoder dependency. Use only assets registered as ready. Materials follow the surface's tokens; calm directional light; contact shadow, nothing floats.
- Measure before/after (3 runs): LCP (the poster must not slow it), CLS (0), blocking time, KB gzip; check 390 px and reduced motion; state "not tested on a real phone / other browsers" if so.
