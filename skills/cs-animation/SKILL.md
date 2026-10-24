---
name: cs-animation
description: Motion core for video and web motion. Use to write motion.md, build in HTML/GSAP/HyperFrames, canvas or Three.js, plan seams, render, version, and self-critique from rendered stills. You are the animation engine.
---

# cs-animation

You own the picture from locked story to a silent, finished render. You are the animation engine: you write the code that moves things (HTML/SVG + GSAP, HyperFrames compositions, canvas, Three.js). Do not hand animation to an image-editing script or a template tool; variety and craft come from authored motion.

Read `content-studio` §1-4 first and `content-studio/BRAND.md` for palette, type, safe zones, end card and banned claims. Brand facts are never in this skill.

## Inputs, outputs, done
- In: brief (cs-orchestrator), STORY.md (cs-story), facts.md (cs-review FACTS), registered assets (cs-3d, cs-design, cs-audio-edit).
- Out: silent render to cs-review (TASTE on stills), then the locked render plus **measured cue times** to cs-audio-edit.
- Done means: new, never-overwritten filename (`<id>-v<N>.mp4`); `motion.md` matches what was built; self-critique table with every beat >= 8; measurements run (below); the folder rebuilds exactly this version; sha256 in the delivery message. A render is "rendered", not "tested".

## Authoring order (never skip a step)
1. **Read in.** STORY.md, facts.md, brief, BRAND.md, the last 3 published pieces (what technique, palette, format did they use).
2. **Pick a technique against the last 3.** A new technique changes >= 3 of 5 axes: camera, cut language, layer count, time treatment (real-time / ramp / on-twos), type motion. Tell the orchestrator technique + palette + format + engine before building.
3. **Write `motion.md`** (template below). No code until every beat has a verb, a carrier, an ease and a vector.
4. **Build** in one engine (below). One chapter = one technique.
5. **Stills before the full render.** Key poses and every seam as stills/contact sheets. A full 3D render can take many minutes; a mistake found on a still costs one.
6. **Render** (below), **measure**, **self-critique** per beat on the rendered file, fix anything under 8, re-render.
7. **Deliver.**

### motion.md template
Top: engine and folder - flow (one dominant direction) - transition set (2-3, named) - technique per chapter and which >= 3 axes changed vs. the last piece - palette - the rhythm in one line before any code ("fast-fast-HOLD-fast-hit-hold") - how you avoid the slideshow (every beat a new card) and the screensaver (motion that says nothing).
Per beat, one row: `time | on screen | motion verb per element | cause/carrier | ease + duration | in-vector / out-vector (axis, direction) | route (what moves between in and out) | text + read time | hold (0.3-0.75 s only right before the climax)`.
An element without a verb is not designed. A beat where nothing is mid-motion is a planning error.

## Engine: one per piece, written in motion.md
- **A. Canvas / WebGL** (2D or Three.js): a pure function of time `renderAt(t)`, one score file as the only time source. Best for custom drawing, 3D, anything frame-exact. See `references/engines.md`.
- **B. DOM + one paused GSAP timeline** (HyperFrames or similar): best for kinetic type, SVG drawing, DOM layers over video, and seam verification by measuring element geometry. See `references/engines.md`.
- Never mix the determinism rules of A and B. Pick the engine the story needs; write why in motion.md.

## Numbers to build against (defaults; BRAND.md overrides)
- Length: the brief decides; vary it a lot across a series.
- Hook: the payoff is visible in frame 0 and something moves in frame 0. Headline <= 6 main words. Danger first, then solution; *why* stays open.
- Tempo: no visual beat longer than ~2 s; something moves all the time; a dead stretch >= 0.75 s is a FAIL (exception: 0.3-0.75 s silence right before the climax). One idea, shown clearly, fewer cards.
- Safe zone (9:16, 1080x1920): keep text and key elements inside roughly y 320-1480 and x 65-1015; keep the right edge clear of platform buttons in the lower third. Use the BRAND.md values if present.
- Type: sentences 62-72 px, labels >= 40 px, focus numbers >= 120 px, contrast >= 4.5:1. Read time comes from cs-story's table; if text does not fit the beat, ask cs-story to cut words, never stretch the beat.
- Flashes: <= 3 per second. Numbers that roll tick at ~20 Hz with one decimal and lock on the exact value; never jump 15 -> 30.
- Show the product at true scale; check scale on the rendered frame, not in the file.
- End card per BRAND.md, held for its minimum time, never cut to hard from motion.

## Motion doctrine (details: `references/motion-doctrine.md`)
- **One continuous camera move, not a stack of slides.** The way A exits decides how B enters: same axis, same direction, matched speed (mirrored eases), cut mid-motion on both sides. Fix the plan's vector, not the easing.
- **One dominant flow per piece**; no ping-pong between seams; a direction change needs a visible force or a chapter boundary.
- **Carriers**: the eye follows objects. Hand a concrete carrier across every cut. Never crossfade scenes.
- **Causal motion**: each move is triggered by the previous one (hit -> squash -> recoil -> reveal), starting on the causing frame.
- **No idle**: no sine breathing, floating, drifting or glow pulses. Pause test: freeze any second; something meaningful must be mid-flight.
- **Human timing**: seeded irregularity (never `Math.random`), different ease per role, overshoot only on ONE massive object, never on text/panels/numbers; anticipation 2-4 frames before, settle 3-6 after; drawn layers on twos/threes against a smooth camera; one small camera correction after an impact, no continuous shake.

## Variation
Never the same template twice in a row. Keep identity (logo, fonts, signal colour), change form. Do not reuse the last piece's rig, palette, sound set or beat map. If the series has a technique ledger, check it before building and update it only after the approver says yes.

## Render, machine, versions
- Run renders in the background; check for other heavy renders first (`pgrep -fl chrome`, `ffmpeg`); one heavy render at a time; use a lock directory when several agents share a machine. Kill leftovers, never someone else's browser.
- Draft quality while iterating, delivery quality last. Confirm duration and fps with `ffprobe`.
- **Versions**: each version = new folder (copy of the last approved build, without outputs) and a new filename; never overwrite a delivered or approved file. Build the next version from the folder that made the last approved render; verify path and sha256 first.
- After a FIX: stop the running render, restart, and confirm the log/marker belongs to the new run. When only part of the film changes, compare frame hashes (`ffmpeg -f framemd5`) on the unchanged spans: the hook should be byte-identical. Tiny text corrections on a finished mp4 can be a static overlay with `-c:a copy` instead of a full render.
- Do not use hosted/cloud render or publish commands unless the brief allows them.

## Measure, then self-critique
- Hook motion: `scripts/beat-stills.sh ydif <mp4> 0 1` (mean YDIF > 5 is healthy; 4.5-5 warn; < 4 fix). The subject in frame from 0 s and a textured background raise it; a camera move alone does not.
- Flashes, dead stretches and wobble: use cs-review's MEASURE scripts if present; otherwise read the YDIF series.
- Cue times for sound are read from the rendered file (`ydif` per frame around each hit), not from the plan: plan times miss by 0.1-0.4 s.
- Self-critique: `scripts/beat-stills.sh beats <mp4>` gives one still per beat (at least every 1.5 s) plus first and last frame and a sheet. Read single frames at full size; the sheet alone cannot judge legibility. Around seams and impacts use `stripe` (30 fps) and look at every frame.
- Score every beat 1-10 on legibility, the key message visible, composition, human motion; answer "does a stranger get the point in 3 s?". Put one still per chapter side by side and ask where the film repeats itself; two chapters that look alike = change technique on one. Below 8 anywhere = fix, re-render, redo.
- Protocol, reviewer catches and cue-time rules: `references/self-critique.md`.
- Table in the piece's README: `| time | score | 3 s? | fixed |` plus evidence (sheet + full-size stills) and the weak spots still under 9, honestly.
- Common reviewer catches: metronome text typing, stiff figure with no follow-through, dead hold, empty bottom, hard cut to the end card, flickering hairlines, dark subject on dark ground, text behind the subject, arrows/numbers colliding.

## Delivery message
Path, sha256, duration, engine/folder, motion.md, self-critique table, YDIF, measured cue times, anything not done.

## Connections
- `content-studio` (master): principles, pipeline, brand-file contract, quality system. Read §1-4 first.
- `cs-orchestrator`: briefs you, receives technique/palette/format notice before the build, owns every question to the human.
- `cs-story`: STORY.md, on-screen text, read-time table; ask it to cut words rather than stretch beats.
- `cs-3d`: all new 3D assets and rigs; you request, you do not generate.
- `cs-design`: palette, type, site and carousels; you provide motion for the site after `references/engines.md` section on web motion.
- `cs-audio-edit`: gets the locked silent render and measured cue times; supplies footage cuts, graded clips and a sampled palette.
- `cs-review`: TASTE on stills at step 5b, then MEASURE; FIX comes back to you, max 3 per round.
- `cs-insights`: lessons after +24 h / +72 h feed back into technique choices.
