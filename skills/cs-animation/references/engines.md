# Engines: canvas/Three.js, DOM + GSAP/HyperFrames, 3D scenes, web motion

## A. Canvas / WebGL engine
- One score file is the only time source; the film is a pure function of t: `renderAt(t)`. Two seeks to the same t give identical pixels.
- All loading (images, fonts, GLB) happens in `init`, before `window.READY = true`; never fetch while seeking. No network at render time.
- Seeded RNG only (mulberry32 or an LCG); never `Math.random`, `Date.now`, `performance.now`, `requestAnimationFrame` as a time source.
- Render by driving headless Chrome over a debugging port: wait for READY, call `renderAt(t)` per frame, pipe frames into ffmpeg. For software GL use SwiftShader flags (`--use-angle=swiftshader --enable-unsafe-swiftshader`). Run outside any sandbox that blocks local ports.
- Repeat the seam table in motion.md and build seams from the same numbers with mirrored eases.

## B. DOM + one paused GSAP timeline (HyperFrames-style contract)
Check your runtime's docs for exact attribute names; these are the rules that bite:
- ONE `gsap.timeline({paused:true})` per composition, registered under the composition's id (`window.__timelines[id] = tl`). A key that differs from the root id freezes the render at t=0. Build synchronously, register last, never `tl.play()`.
- The root has `data-duration`/width/height; style it by `#id`, not class. Render length = root duration; a timeline running past it is cut.
- Sub-composition files wrap everything (style, script, markup) in `<template>`; standalone roots must NOT be wrapped.
- Use `fromTo` instead of `from` in sub-compositions and timed scenes (the host re-seeks; `from` snapshots at registration and desyncs on seek-back). Later tweens on the same property: `immediateRender:false`.
- Determinism: no `Date.now`, unseeded random (also `gsap.utils.random`, `stagger:{from:"random"}`), network fonts/images at render, hover/scroll state, `setInterval`. `repeat:-1` only with a finite root duration.
- Layout: build the visible end state in static HTML/CSS first, animate from/to it. Centre with flex/`inset`, not `translate(-50%,-50%)` on a node GSAP also moves. Transformed elements must be block-level with size. Fonts need `@font-face` against local files.
- Media: never `crossorigin` on video/audio; do not animate `.clip` visibility/dimensions of timed media - animate an untimed wrapper; source cuts are several `<video>` elements with media-start + duration, not keyframes. Compositions are normally silent (muted); sound is mixed by cs-audio-edit.
- Validation order: lint -> check (layout, motion, contrast; a lint error can silently disable the checks, so a "0 samples" report is not clean) -> snapshots at midpoints and seams -> pose check on the subject (name the poses that prove the motion, including the end state) -> LOOK at the PNGs before tuning warnings -> render -> self-critique.
- Any "static for 3 s+" warning is fixed with a route (reveal, camera, sequenced life), not with decorative drift.
- Network commands of the toolchain (publish, cloud render, add from registry, upload) need the approver's yes via the orchestrator.

## 3D scenes (Three.js)
- Assets come from cs-3d; you never generate. Request: beat, role, real dimensions, where it stands.
- Pin one Three version for core and addons (import map to local files); render from the seek event, not `setAnimationLoop`; fixed size, `renderer.setPixelRatio(1)`; build-heavy work must complete before the first frame.
- Real scale: glTF is metres, Y up. Lock all objects in the scene to one unit. Check scale on the RENDERED frame: a `measure()` helper projects two points of known distance and returns pixels; deviation <= 3 %.
- Pivot at bottom-centre for props standing on the ground; contact shadow under everything that stands - nothing floats.
- Camera is a function of t with ONE writer. Motion with intent: establish -> travel -> arrive; slow push-in in tension; one small kick on impact; no idle orbit. Subject in frame from 0 s.
- Falls/impacts: cause visible before the effect; contact mandatory before the fall; hit-stop 3-4 frames via a time-remap; limbs lag the body 2-4 frames; no flips that physics would not produce. Numbers (speed, friction, angles) come from facts.md, never from memory.
- Characters and rigs: many small parts with their own joints and names; limbs as one contour through points, not tube + sphere joints. Check each pose still against the reference sheet in BRAND/assets before the full render.
- Materials: low-poly + flat or calm PBR in the palette; photoreal textures only when the texture is the subject. No glow, neon, or blur over the whole frame.
- CSS-3D without WebGL: static `perspective` on the stage, never on the world; one `cam` object applied in fixed order `translate3d -> rotateX -> rotateY`; keep the world element free of filter/opacity<1/overflow/clip-path (they flatten depth); invert camera intent onto the world. Scale alone is fake depth.
- 3D over footage: render a PNG sequence with alpha and hand it to cs-audio-edit, or build the clip into the composition.

## Drawn layer (hand-drawn SVG, line boil, rotoscope)
One source of imperfection per drawing; variable stroke width; no glow/shadow/gradient strokes; boil only on strokes (12 fps or a new line every 3rd frame), never on text, photo or logo. Animation sections carry the footage's palette and grade: ask cs-audio-edit for a sampled palette. Over real footage deliver an alpha PNG sequence, or build the clip into the composition; privacy masks come BEFORE effects.

## Web motion (site, not video)
Interactive UI follows UI rules, not film rules: < 300 ms, never ease-in on UI, respect `prefers-reduced-motion`, animate transform/opacity only, no layout thrash, motion that explains state. Do not mix with the film doctrine. Coordinate with cs-design.
