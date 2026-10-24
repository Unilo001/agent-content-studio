# Self-critique, versioning and lessons

## Stills protocol
1. `scripts/beat-stills.sh beats <mp4> [t1 t2 ...]` -> one PNG per beat + first/last + a sheet.
2. Read each beat still at full size. The sheet shows rhythm and repetition, not legibility.
3. At seams and impacts: `stripe <mp4> <from> <to>` (<= 2 s) and read every frame.
4. Score each beat 1-10 on: legible at phone size, key message visible, composition (frame filled, nothing under the safe-zone edge), human motion (follow-through, no metronome).
5. Answer in writing: "does a stranger get the point in 3 s?" and "where does the film repeat itself?".
6. Fix what is < 8, re-render, repeat the protocol on the NEW file.

## Reviewer catches to pre-empt
Metronome text typing; stiff figure without follow-through; dead hold; empty bottom or half; hard cut to end card; flickering hairlines; dark on dark; text behind the subject; arrow/number collisions; same ease on everything; every beat a new card; pulse dots; everything entering at once; perfectly smooth camera; a technique used for the third time in a row.

## Versioning
- Folder per version, filename per version, sha256 in every message. Never overwrite delivered/approved files.
- After a FIX: confirm the render marker/log belongs to the new run before reporting.
- Partial changes: frame-hash the unchanged spans against the previous version.

## Cue times for sound
Measure from the rendered file: YDIF per frame around each hit; the peak frame is the cue time. Send `{id, t_s}` rows to cs-audio-edit with the file sha256. A new picture version means new cue times; never reuse old ones.

## Lessons
When the approver or cs-review gives a verdict worth keeping, tell cs-orchestrator in one dated line so it can go into BRAND.md taste rules. Record technique, flow and palette used for the series ledger.
