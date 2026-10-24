# Motion doctrine: vectors, seams, timing, data

Read before writing flow, transition set and seams in motion.md.

## 1. Vector law
| Rule | What | Common mistake |
|---|---|---|
| Axis | x stays x, y stays y, Z stays Z across the cut | sideways exit, vertical entry |
| Direction | never mirror. On Z the direction is the sign of d(scale)/dt: growing = push (camera forward), shrinking = pull | shrinking exit answered by grow-from-small entry (the default entry, so the most common error) |
| Speed | entry start speed ~ exit end speed: mirrored eases, same distance and duration (two halves of one `power4.inOut`) | gentle `power2.out` entry after a `power4.in` exit |
| Phase | the cut lands mid-motion on both sides; the incoming side picks up >= 50 % along its path | exit settles before the cut, or entry starts from rest |
If the plan mismatches, fix the plan (the vector), not the easing.

## 2. Flow and reserved vectors
- One dominant direction per piece (e.g. left = "next beat"). All ordinary seams use it.
- Reserved, they mean something: up = elevation (conclusion rises above the previous); Z forward = deeper into the same thought; Z backward = ARRIVAL (something larger lands, the payoff); scale burst out = leaving a world.
- Never two consecutive seams in opposite directions without a visible force (hit, bounce) or a chapter boundary.
- Use 2-3 transition types per piece and repeat them. Default = cut-the-curve along the flow. The next piece should pick a different flow and set.

## 3. Carriers and causality
- The strongest seam delivers a concrete carrier across the cut with matched position AND speed: the subject mid-action, a line, a number flying into the next slot, an object docking into the next layout, a word group in a waterfall cut.
- No natural carrier: the scene's hero carries it (partial travel + early fade, entry mid-flight). Never crossfade.
- Causal chain: cause -> squash -> release -> flight -> impact -> recoil -> reveal. Effects start on the same timeline position as the cause. Reactions scale with mass (big rebounds slowly, small snaps). A force licenses a direction change; an unprovoked flip is ping-pong.

## 4. No idle: the routes
A scene that finished its entrance with seconds to spare is a planning error: add story, not wobble. Name the route per phase in motion.md:
| Route | What |
|---|---|
| Staged reveals | hold content back, pay out on beats; the frame gains information (default with >= 2 content groups) |
| Camera with intent | mapped scale+pan path: establish wide -> travel -> arrive on the subject |
| Sequenced life | number rolls, line draws, curve fills, sensor "reads" |
| Animated sequences | elements play out a beat |
Not idle: line boil on drawn strokes, stepped grain (12/8/6 fps), diegetic pulses that show something is really working. Pause test: freeze any second; something meaningful is mid-flight.

## 5. Timing intents
- Single entry <= ~0.8 s (longer build-up = stagger across elements, not one slow element).
- Exit ~ 75 % of entry (cut-the-curve inverts it: entry ~ 127 % of exit).
- Total stagger <= 0.5 s; with 8+ elements tighten the delay or stagger only the first few.
- Like elements share ONE ease+duration; variety comes from seeded offset, not unique pairs.
- Forbidden: `bounce`, `elastic`; `back` only on the single massive object. Text, panels, labels, numbers: `power4.out` / `expo.out`.
- Following motion: `x += (target - x) * (1 - exp(-k*dt))`. It lags by speed/k, so raise k or add lead.

## 6. Seam catalogue (pick from it, do not invent)
Numbers from a 1920-wide canvas; on 9:16 (1080x1920) a horizontal partial travel of 12 % is ~130 px, vertical ~230 px.
| # | Technique | Use | Out | In | Ease out/in |
|---|---|---|---|---|---|
| 1 | Zoom-through (Z forward) | text change inside one thought; headlines/short phrases only | scale 1->1.2, blur 0->10 px, opacity ->0.15, 0.2 s | scale 0.75, blur 10, opacity 0.15 -> 1, 0.5 s | `power3.in` / `expo.out` |
| 2 | Inverse zoom (Z backward) | arrival/payoff, held end state | 1->0.8, blur 10, ~0.2 s | 1.25->1, ~0.5 s; no grow-from-small in the seam window | `power3.in` / `expo.out` |
| 3 | Cut the curve | DEFAULT scene boundary along the flow | partial travel ~12 %, 0.33 s; opacity done at 25-30 % of travel | from +travel, lights at opacity 0.35 mid-path, 0.33-0.42 s (>= exit) | `power4.in` / `power4.out` |
| 4 | Waterfall cut | text-to-text, per word | word -230 px 0.34 s, fade 0.18 s, stagger +0.022 s in reading order | from +230, opacity 0.35, 0.3 s, gap 0.05 s x 0.84 per word | `power4.in` / `power4.out` |
| 5 | Rack-focus blur cut | same surface, state change; <= 1 per ~8 s | blur to peak 8-12 px, scale ~1.06 | swap AT peak blur, same direction | `power2.in` / `power2.out` |
| 6 | Waterfall entry (in-scene) | title cards, list intros | - | binary opacity via `set`, Y from below, overlap +-2 frames, shrinking gaps | `power4.out`, never `.inOut` |
| 7 | Nudge curve (in-scene) | a group moves to make room | 3 phases: `power3.in` ~10 % distance in ~20 % time -> `none` ~65 % in ~18 % -> `power4.out` ~25 % in ~62 % | reveal new content UNDER the burst | tail >= 3x ramp-in in time |
Blur rules: text peak 10 px (20 px smears glyphs), full-frame surfaces 18-20 px; same peak on both sides; blur the wrapper, never children; never blur and fade in the same tween; never blur a `<video>` directly. Directional motion blur only on 1-3 snapping beats and only when the subject crosses more than about one element width per frame; never on text to be read.
White-flash guard: some seams have a window where summed opacity < 1; whatever is behind shows. Give the root an opaque background (DOM) or paint a full-frame background first (canvas), or the renderer composites over white and flashes at every seam, worst on dark films.

## 7. Seam plan
Write the seam table BEFORE the master timeline: one row per seam with cut time, technique, exit and entry vector (axis + sign; for Z the scale sign) and carrier. In DOM engines, generate seam code from that table so seams pass by construction, and verify by measuring element geometry around each cut. Rules a script will not see: any edit to a scene's first/last ~1 s reopens its seams; new VO reopens seams it touches (re-time to actual word times); a clip with a start time before its entry tween shows at start opacity (set opacity 0 AND start = cut time). In canvas engines geometry checks do not apply: keep the same table, build seams from the same numbers, and inspect a 30 fps stripe around each cut.

## 8. Anti-patterns
| Don't | Do |
|---|---|
| build each scene in isolation | seam table first |
| crossfade between scenes | cut-the-curve or a real carrier |
| exit completes, then the scene swaps | cut mid-motion |
| entry from rest after the cut | entry >= 50 % along its path |
| `.inOut` on both sides of a cut | `.in` out, `.out` in |
| equal gaps in a cascade | gap x 0.84 |
| zoom-through on body text | headlines/short phrases only |
| reaction a few frames after the cause | same frame |
| action jumps straight to result | 0.3-0.75 s silence |
| reserved vectors as decoration | the flow by default, others only with meaning |
| non-opaque root | opaque background |

## 9. Data and numbers in motion
- One instrument per beat; successive numbers live in the same visual space, only the value changes.
- Bars and fills with `scaleX`/`scaleY` + `transform-origin` (never width/height); fill and number share the SAME ease and land on the same frame. Ring length from `getTotalLength()` at setup.
- Read-out curve: ONE driver `p` for marker and number; write text only when the data index changes.
- A landed key figure stays legible >= 0.8 s while something else (camera, subject) still moves: the number stands, the film does not.
- No pie charts, dual axes, grids/ticks/legends or chart-library look; build with SVG/canvas.
- A drawn line (arrow, axis, underline) must land on something and have a job; stagger 70-80 % of the previous segment.

## 10. Scene patterns (choose against the last 3, not as templates)
| Pattern | Signature |
|---|---|
| count-up dataviz | number counts up while the instrument scales; the camera shoots straight THROUGH the instrument's centre into the next scene |
| camera journey | the camera is the actor: dive in -> content acts while camera holds -> travel to the consequence -> land |
| zoom-out reveal | open tight on one detail, ONE decaying zoom-out reveals the whole, then a locked frame |
| video-text pivot | the clip slides aside INTO the space the big stat fills; weight transfer reads as one event |
| comparison split | two equally heavy things at once from opposite sides, never sequential, never > 2 (comparison of 3D subjects: ONE scene) |
| spatial pan stations | stations on one oversized canvas, one camera pans station to station, lands held on the last |
| kinetic type beats | one anchor at centre, beats replace each other in place with a DIFFERENT entrance per phrase (a reused `punchIn()` reads "flat but competent") |
| title/logo lockup | low motion is the payload; the mark is built (stroke by stroke, camera through negative space) and lands in motion |
Devices: impact frame (hit-stop + short flash; counts toward the flash limit; freeze to the next beat); freeze frame (greyscale + contrast, slow 1->1.05 zoom, ring around the key object); light as a multiplied radial gradient from the source; a horizon tilt where the world tips until the subject is upright and springs back (max one per piece); paper collage on twos; match cut on a line (two measured key points, never by eye).
Surfaces: no full-screen linear gradients on dark backgrounds (they band in H.264), use solid/radial + local light; hairlines under ~2 px flicker in compression.
