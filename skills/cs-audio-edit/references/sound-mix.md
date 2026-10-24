# Sound: spotting, library, mix, master, mux, handover

Generic mixing craft is assumed; these are the numbers and patterns that pass review.
## 1. Before touching a level
Top of `audio/SOUND.md`: lead role (VO / real sound / music with a yes); targets (see SKILL.md); the picture file and its sha256 you mix against.

## 2. Spotting: `audio/cues.json`
One row per sound event; JSON list of objects with exactly these fields (unknown = `null`):
| field | type | meaning |
|---|---|---|
| `id` | text | short unique name (`fall`) |
| `t_s` | number | event time in the piece, seconds, measured on the rendered picture |
| `adelay_ms` | integer | delay of the file in the mix at 48 kHz: `round(t_s*1000 - transient_ms) + offset_ms`; goes into `adelay=` unchanged |
| `offset_ms` | integer | deliberate deviation from the visible cause (0 = none; negative = sound before picture); its own field, never baked into `adelay_ms` |
| `file` | text | source file |
| `cut_s` | `[start, end]` | used part of the file |
| `transient` | number | transient position in the source, seconds from file start |
| `role` | text | `accent`, `bed`, `air`, `vo`, `transition` |
| `measured_by` | text | who/what measured `t_s` |
| `visible_cause` | text | what in the picture the sound answers |
| `perspective` | text | e.g. `close, dry` |
Check: `adelay_ms - offset_ms + transient*1000` equals `t_s*1000` within one sample.
- Only 2-3 events per shot carry sound; too many literal sounds fight the VO.
- Each important sound answers: what physically made it, where it is relative to the camera, what feeling it adds. Close = more transient, dry; far = less treble, softer transient; no reverb on a close hit.

## 3. Library and sources
- Own recordings first; CC0/licensed recordings second (licence file and URL in SOUND.md). Build a small local library of cut-outs by category (impacts, tyre/road, wind, room tone, mechanical, cloth); catalogue each with source, licence, duration, transient time.
- New library file: download into its own empty folder, listen-proxy by measuring (levels, silence, spectrogram) and watch for tonal accidents (a 400 Hz tone that looks like a "ping" may be wind in the source - check the original before concluding).
- Line in SOUND.md per source: `time | file + cut | licence | rule status | processing`.

## 4. Numbers for life and air
| Rule | Value | Why |
|---|---|---|
| Room tone | under everything, 0.0 s to last sample (e.g. wind/room cut-out, HP 80 Hz, LP 5 kHz, ~-6 dB) | digital silence reads as an error; a generated picture without a bed looks synthetic |
| Bed vs accent | bed 12 dB under accents; duck 3-4 dB for ~200 ms under each accent | contrast, not a wall |
| Hit over bed | peak (20 ms) >= +6 dB over RMS of the 300 ms before | a weak end-card hit = FIX |
| VO over the rest | >= +5 dB in speech gaps, aim 8-10 | under +5 = FIX |
| Simultaneous elements | max 3 in the foreground | beyond 3 the brain hears one mass |
| Before the end card | bed exhales 0.45 s before; card lands in near-silence | silence before the one thing to read |
| Variation | never the same sound twice: new cut, +-14 ms, +-2.5 dB | identical hits read as generated |
Hits that must be felt: transient on the contact frame (not the clip start), silence before, room tone swells back in after; a tail overlapping the hit makes the limiter duck it. A logo hit that is only bass has weak K-weighted momentary level: add broadband wind bloom 250-6500 Hz with a fast attack.

## 5. Signal chain in ffmpeg
```
# VO per line: trim silence at both ends, tempo, normalise the line, 48 kHz mono, place at cue (ms)
[0]silenceremove=start_periods=1:start_threshold=-45dB,areverse,silenceremove=start_periods=1:start_threshold=-45dB,areverse,
   atempo=1.12,loudnorm=I=-16:TP=-2,aformat=sample_rates=48000:channel_layouts=mono,adelay=200|200[a]
[a][b]...amix=inputs=N:normalize=0,volume=3dB,asplit=2[vo][vk]
# room tone from 0.0 s
[R:a]aresample=48000,atrim=30:<30+D>,asetpts=PTS-STARTPTS,highpass=f=80,lowpass=f=5000,volume=0.5,afade=t=out:st=<D-0.6>:d=0.6[room]
# real effect: cut from the transient, EQ/fade/level only, at the cue
[S:a]aresample=48000,atrim=<in>:<out>,asetpts=PTS-STARTPTS,lowpass=f=6000,volume=0.8,afade=t=in:d=0.05,afade=t=out:st=<x>:d=0.5,adelay=<ms>|<ms>[fx]
# duck: the sidechain key MUST be padded or everything after the last VO line goes digitally silent
[vk]apad=whole_dur=<D>[vkp];[room][fx]amix=inputs=2:normalize=0:duration=longest[sfx]
[sfx][vkp]sidechaincompress=threshold=0.015:ratio=4:attack=20:release=300:makeup=1[sfxd]
[sfxd][vo]amix=inputs=2:normalize=0:duration=longest,alimiter=limit=0.8:level=disabled,apad=whole_dur=<D>,atrim=0:<D>[a]
```
- Sidechain alone does not give the VO margin: also duck explicitly around VO and 200-300 ms before hits with `volume=0.5:enable='between(t,a,b)'`, ratio 4-5.
- `amix` with `normalize=0` or levels drop as you add tracks.

## 6. Master and mux
Two-pass linear loudness normalisation to the target (I -15, TP about -2, LRA 11), `aformat=sample_rates=48000:channel_layouts=mono` right after loudnorm (resampling right after it fails on channel layout, and loudnorm can output 192 kHz), one AAC encode at 192 kb/s, mux with the picture copied:
`ffmpeg -i picture.mp4 -i audio.m4a -map 0:v -map 1:a -c copy -t <duration> out.mp4`
- Measure TP only on the finished AAC. Encode once from wav. An approved AAC is copied (`-c:a copy`), never re-encoded from an approved mix.
- Missed the target with the TP ceiling? Fix the dynamics (duck, cut peaks before the limiter), not more gain.
- Tiny text corrections on a finished mp4 are done by cs-animation (or an ffmpeg overlay with `-c:a copy`); the sound stays untouched.

## 7. Self-check
`scripts/loudness-check.sh <final.mp4> [--hits 7.55,7.72] [--vo vo-stem.wav --sfx sfx-stem.wav]` and `scripts/cue-sheet.sh <final.mp4> <cue_s>` per hit; read each sheet. More tools: `ffmpeg -i f -lavfi showspectrumpic=s=1200x400 spec.png`; `-af silencedetect=n=-50dB:d=0.3`; momentary loudness by `ebur128` with `metadata=1`. Band measurements do not tell synthetic from real once VO is present; the verdict on "real" rests on the source list, not on numbers.

## 8. Troubleshooting
| Symptom | Do |
|---|---|
| VO buried | duck bed/effects explicitly + sidechain ratio 5; cut 1-4 kHz in the bed; never fix with the limiter |
| VO harsh/metallic | new take (budget), not broadband denoise; lower limiter drive |
| Hit lacks weight | silence before, transient on the contact frame, room tone after; duck competing layers |
| Sound "boring" | more events with a cause in the picture, variation between similar hits, dynamics; not more stacked layers |
| Sound "irritating" | fewer, shorter accents, less treble, no repeated tone; check nothing tonal holds |
| Audible loop | longer cut, crossfade, new cut per repeat |
| Silence after VO | `apad=whole_dur` on the sidechain key; measure RMS per 50 ms |
| TP over -1.0 | lower normaliser TP, cut transients before the limiter, re-encode from wav, measure again |
| Hit gone on phone | bass-only: add broadband content; check the 150 Hz high-pass proxy |
| Wrong cue | re-measure the picture (30 fps stripe, `cue-sheet.sh`); fix `cues.json`; remix |
Fix order: source, cut, balance/duck, track, bus, loudness, encode, measure.

## 9. Platform-sound variant
If the platform lets the human attach library audio when posting, deliver a variant with no music and no VO: only real recording sound and room tone, same level rule. Mark `PLATFORM-SOUND: <suggested sound or type, where it comes in>` in SOUND.md and send the note to cs-story for the caption file. Filename contains `-platform-sound-`. The human picks the sound and posts it.

## 10. `audio/` folder and SOUND.md
```
audio/
  SOUND.md        sources, processing, measured numbers, rule status, "measured, not heard"
  cues.json       all events, schema above
  timing.json     VO lines: id, start, end, text
  vo_<n>_t<k>.mp3 / .align.json / transcript_<n>_t<k>.json
  mix<NN>[v].sh   the script that makes exactly this version
  vo-stem.wav  sfx-stem.wav   (same length/start as the mix)
  <piece>-audio-v<N>.wav / .m4a
```
```
# SOUND <piece> v<N> - <date>
Picture: <render.mp4> sha <8> - Mux: <out.mp4> sha <8> - Duration <s>
Lead: VO | real sound
Measured (final AAC): I <x> LUFS - TP <x> dBTP - LRA <x> - sound from 0 s <PASS> - HP150 loss <x> LU - VO margin min <x> dB
| time | source (file, cut) | licence | rule | processing |
Cues from: <reviewer file | animator message | own 30 fps reading>
Not heard by a human.
```

## 11. Handover to cs-review
One message, paths not contents, copy to cs-orchestrator:
```
<piece> v<N> sound - <out.mp4> sha256 <8> - picture <render.mp4> sha256 <8> - <duration> s
loudness: I <x> LUFS - TP <x> dBTP - sound from 0 s <PASS> - HP150 <x> LU - VO margin <x> dB - <WARNs>
sources: <short> - platform-sound variant: <suggestion or "no">
cues from: <source>; cue sheets: <paths>
files: <piece folder>/audio/
Measured, not heard by a human.
```
Fix = new mix with a new filename, self-check again, answer with the new sha. Reviewers grant no exceptions; only the orchestrator may accept a known artefact. Do not post before the QA answer; files to the approver and the queue go through the orchestrator.
