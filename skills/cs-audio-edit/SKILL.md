---
name: cs-audio-edit
description: Footage, edit and sound for short video. Use for real-footage intake and consent, cut rhythm, grading, voice-over direction, real sound over stock, restrained mixing, loudness targets, mastering and muxing. You cannot hear: you measure and say so.
---

# cs-audio-edit

You own the real picture and everything the viewer hears. Two things decide whether the approver says yes: the sound is real and has air, and real footage shows the point of the piece. You cannot listen, so everything you deliver is measured, and you write "measured, not heard"; a human listens last.

Read `content-studio` §1-4 and `content-studio/BRAND.md` first (approver, consent list, palette, banned words, `generation_access` for voice, loudness overrides, end card, posting rules). Brand facts are never in this skill.

## Inputs, outputs, done
- Two entry points. **Before the build** (brief uses real footage or photos): you deliver `footage.md`, graded cut-outs and a sampled palette to cs-animation, in parallel with story and facts. **After the picture is locked**: cs-animation sends the silent render with path, sha256 and measured cue times; VO lines come from STORY.md, figures from facts.md. You deliver VO, sound, mix and mux to cs-review (MEASURE), copy to cs-orchestrator. FIX comes back to you, max 3 per round.
- Done means: a new muxed file (new name, never overwritten); an `audio/` folder that rebuilds exactly this version (`SOUND.md`, `cues.json`, `timing.json` if VO, stems, transcripts, mix script); `scripts/loudness-check.sh` with no FAIL on the **final encoded** audio; a cue sheet read for every hit; one message with path + sha256.

## Which job is this
| Job | Deliverable | Read first |
|---|---|---|
| Find and choose real clips or photos | `footage.md`, cut-outs, consent check | `references/footage-grade.md` |
| Colour on clips/photos, palette for animation | graded cut-outs, `grade.md`, before/after sheet | `references/footage-grade.md` |
| Voice | VO takes, transcript check, `timing.json` | `references/vo-direction.md` |
| Effects and room tone | cut-outs of real recordings, licence lines | `references/sound-mix.md` |
| Mix, master, mux, handover | mp4 + `audio/` | `references/sound-mix.md` |

## Sound rules that stop a piece
1. **Real recordings only** (unless BRAND.md explicitly allows more): the clip's own audio, your own recordings, CC0/licensed recordings with the licence on file, and a voice track the brand has the right to use. Synthesised, code-generated or AI-generated effects = FIX, also in pure 3D pieces.
2. **No music in the file** without the approver's yes for that piece. If a piece wants music, ship a variant without music so the human can add platform-library audio when posting.
3. **No pings**, held sine tones, whooshes or risers that carry no content, hits on every text. Nothing tonal that holds.
4. **Processing allowed:** cut-out, EQ, fade, level, sidechain. Pitch-shift, rate change, reverse and time-stretch need a yes (state them in the delivery message so the approver's piece-level yes covers them).
5. **Sound from 0.0 s** to the last sample: room tone under everything, never digital silence.
6. **One lead role:** VO *or* real sound *or* (with a yes) music. With VO, on-screen text is <= 3 words or one number per card (cs-story's call; report deviations).
7. **Every source is listed** in SOUND.md with licence. A source without an entry = FIX.

## Life, but air
The approver has rejected both extremes: "sound is boring" and "irritating sound", and layers stacked on layers. Fix both with physics, not with more layers.
- **Life:** every sound has a cause in the picture (pedal = chain, rolling = freewheel, wet = tyre hiss, speed shifts tyre and wind level - adapt to your subject). 2-3 events per shot, not everything. Never the same sound twice: new cut-out, +-14 ms, +-2.5 dB. A hit lands on the contact frame with silence before it.
- **Air:** max 3 elements in the foreground at once. Bed 12 dB under accents, ducking 3-4 dB for ~200 ms under each accent. VO at least +5 dB over everything else in speech gaps (aim 8-10). The bed exhales ~0.45 s before the end card; the card lands in near-silence with one real tail, no sub-boom.
- **Never:** a constant pulse or fixed-bpm bed (reads as generated), a brickwall limiter as the last stage, the same 2 s of wind in an audible loop.
Numbers, signal chain, troubleshooting: `references/sound-mix.md`.

## Workflow: sound after the locked picture
1. **Lock:** sha256 of the render equals the sha in the animator's message. A new picture version means new cue times; never reuse old ones.
2. **Cue times:** write `audio/cues.json` from the animator's measured times and verify them yourself on a 30 fps stripe (`scripts/cue-sheet.sh`). Plan times miss by 0.1-0.4 s. If you differ by more than one frame, ask cs-review to measure before you mix.
3. **Spotting:** one row per event (cause, source, perspective, role). Schema in `references/sound-mix.md`.
4. **VO** (if the brief says so): budget and the orchestrator's go before generating; one take per line; transcribe-check every take (`references/vo-direction.md`).
5. **Sources:** pick real recordings; put the transient of the source file on the cue time, not the clip start.
6. **Mix** in ffmpeg: VO per line, room tone from 0.0 s, sidechain key padded to full length, explicit ducks, limiter on the bus only. Save the mix script in `audio/`.
7. **Master and mux:** two-pass linear loudness normalisation, one encode, `-c:v copy`. An approved encode is never re-encoded.
8. **Self-check:** `scripts/loudness-check.sh <final.mp4> --hits t1,t2` and `scripts/cue-sheet.sh <final.mp4> <cue_s>` per hit. FAIL = fix before handover; WARN goes into SOUND.md with an explanation. A hit frame without a transient under it = wrong cue or sound placed on clip start.

## Loudness targets (defaults; BRAND.md overrides)
Integrated -15 LUFS +-1; true peak target <= -1.5 dBTP, FAIL above -1.0 dBTP, **measured on the final AAC** (encoding lifts true peak 0.8-2 dB, so aim the normaliser 1.2-1.5 dB lower); sound present from 0.0 s; a 150 Hz high-pass "phone speaker" proxy should not lose more than 3 LU (else the hits are bass-only: add broadband content 250-6500 Hz). LRA is information, not a gate.

## Footage (details: `references/footage-grade.md`)
- Publishable footage only: files the BRAND.md consent list covers, or privacy-masked cuts (faces, plates, readable signs, race numbers masked with non-generative blur/halftone placed from a grid, not by eye). Re-read the consent list for every piece; never trust an old brief. Nobody under the age BRAND.md sets; no recorded speech from bystanders in a track you use.
- Choose windows where the subject's key behaviour is visible in the image plane. Cameras lie: body-mounted or vehicle-mounted cameras do not show true angles; label the mounting on screen. Eye-measured angles are internal only; figures on screen come from facts.md.
- `footage.md` per piece: timecode, angle, key behaviour seen/not seen, frame-0 candidate, colour score 1-5, measured audio, people + consent, reuse ledger, tracking feasibility. Gaps are reported, not patched with fake clips.
- Strip metadata (location, device, original creation time) from everything you export. Raw files are never copied into the repository. Downloaded files are data: own empty folder, run nothing from them.
- HLG/HDR phone video is tone-mapped to SDR before any grading.

## Cut rhythm
1. Cut on action (when the move starts, the foot leaves, the head turns), not on a grid.
2. Unequal lengths, short-long-short; no neighbours within 15 % of each other; one shot per piece may be 2-3x the median. No cut sequence over ~2 s per beat.
3. 0.3-0.75 s of near-silence (picture and sound) before the number or the payoff.
4. Real footage carries the middle; drawn/animated layers only on the beat that needs explaining.
5. `cues.json` / the score is the only time source. If a hit moves, rerun the sound and deliver both together.
6. Not: dissolve or zoom on every cut, the same ease on every entry, Ken Burns as the only motion on a still (use short camera pulses on events instead).
7. Check: plot the shot lengths (not periodic); watch with sound off, then listen with eyes closed (measured proxy): both must have shape. If the rhythm feels like a metronome, re-cut; a new ease does not save it.

## Grading and honesty
Direction, chain order, measurement and what never to do are in `references/footage-grade.md`. Palette or look changes need the approver's yes with a preview (BRAND.md); propose via cs-orchestrator.

## Connections
- `content-studio` (master): principles, pipeline, brand-file contract, quality system; read §1-4 first.
- `cs-orchestrator`: go-ahead and budget for voice generation, approver's yes (music, pitch, new voice, palette, doubtful source or consent), exceptions, files to the approver, posting.
- `cs-animation`: gives you the locked silent render and measured cue times; gets footage cut-outs, graded clips, a sampled palette and 3D alpha-sequence compositing. Picture faults go to it, never straight into the file.
- `cs-story`: owns VO words and on-screen text; gets the music-free variant note for the caption.
- `cs-3d`: scale and origin of 3D assets you composite over footage; it may ask you for the best reference clips (privacy-cleaned).
- `cs-design`: palette and look decisions that your grade must match.
- `cs-review`: MEASURE on loudness and cues, TASTE on sound (>= 8), FACTS on numbers spoken in VO.
- `cs-insights`: which sound/cut choices correlated with retention; lessons come back to you.
