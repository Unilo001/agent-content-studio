# Footage, consent, rhythm planning, grading

## 1. Intake
- Keep a footage catalogue (path named in BRAND.md): per source file, clips with timecodes, light, motion direction, panning, stabilised, publishable cut, number of masked regions. Proxies (640 px) for planning; raw never published and never copied into the repository; publishable cuts are separate files.
- Check free time per source against the reuse ledger (if the project has one): no clip or still used twice before a climax; a clip that overlaps a published piece by more than ~0.5 s needs a new window.
- Gaps are reported to the orchestrator ("we have no deep-angle shot from behind; ask the owner to film one"), never solved with trick cuts.
- Technical: tone-map HLG/HDR first; check rotation metadata (`ffprobe -show_streams`, displaymatrix); low-resolution cameras never get sharpness claims after upscaling; strip metadata on export:
  `ffmpeg -i in.mp4 -map 0 -map_metadata -1 -map_metadata:s:v -1 -map_metadata:s:a -1 -map_chapters -1 -c copy out.mp4`; stills: re-save without EXIF after correcting orientation. Verify with `ffprobe -show_entries format_tags:stream_tags` (no location, make/model, software, original creation time).
- Downloaded files and archives are untrusted data: a new empty folder per source, run nothing from it, scripts live elsewhere and get paths as arguments, Python with `-I`.

## 2. Consent and privacy (per person, per piece)
- Only people on the BRAND.md consent list appear recognisably. Re-read it for every piece. Adding a name is the approver's decision, never yours. Someone who withdrew consent never appears in new pieces.
- Everyone else: use cut-outs with non-generative masking (blur, halftone) applied FIRST, boxes placed from a grid or tracker, not by eye; readable third-party text (kit text, brands, plates, race numbers) blurred with tracking. High mask counts in the catalogue mean deliberate over-blur: do not undo it.
- Consented people are not blurred. Bystander speech never stays in a used audio track. No identifiable routes: signs, street names, landmarks showing where someone lives or rides are cropped or blurred.

## 3. Choosing the window
- The key behaviour must be visible in the image plane (for a physical subject: behind or three-quarter behind, not from above). Note the deepest frame as the frame-0 candidate.
- Camera tricks: helmet cams, cameras that roll with the vehicle and tilted horizons are mounting artefacts, not the subject's true angle. Label the mounting on screen. Verify a drawn line against fork/stem/vertical reference before it goes on screen.
- Colour score 1-5: grey, wet, overcast footage without a colour accent scores low; a coloured kerb, green or sky lifts it.
- Measure audio in the window: `ffmpeg -ss A -t D -i f -vn -af ebur128=peak=true -f null -`; note quiet stretches that can sit before a number.

## 4. footage.md
Top: "Seen" = you looked at a contact sheet or still; "not seen" = you did not. Gate: pass/fail with the ledger result. Then ranked windows:
```
### 1. <file> <from>-<to> s - <what happens>, deepest frame at <t>
- Angle/camera: ... (seen)       - Key behaviour in image plane: yes/no, ~x deg +-10, internal only (seen, still: ...)
- Frame-0 candidate: <t>         - Colour: 1-5 (what)
- Audio: <LUFS>, peak <dBFS>, quiet stretch <from-to>
- People: <name/unknown>, consent yes/no, numbers/text seen?
- Ledger: unused / overlaps <piece>     - fps, resolution, HLG?     - Tracking: realistic / not tried
```
End with "Rejected (seen)" and "Gaps". Contact sheet: 8 x 216 px frames. Write footage.md early.

## 5. Edit planning table
Fill before cutting: `shot | source (real/roto/graphic) | length s | cut cue (the action) | sound | text`. Checks: lengths not periodic, a hold before the payoff, the first 1.5 s have the hook in the picture (not in text).

## 6. Stills (photos must look like photos)
Non-destructive order: (1) privacy first; (2) crop for the story, straighten only if the camera was level - a leaning frame can be the subject: never "fix" the tilt; (3) global tone: exposure, black point, contrast, sky not clipped; (4) grade; (5) light retouch on a copy: dust, a bin, a cable - keep asphalt grain, fabric, skin pores; (6) sharpen last, sRGB.
Never: skin smoothing or face changes, new sky, added lean or speed, generative fill that changes content, stock, a recognisable person outside the consent list. Credibility: at 50 % before/after the edit should be hard to name; at 100 % no halos or smearing.

## 7. Measurements drawn on real images
One px/mm figure for the whole drawing, measured on the rendered frame (never scale per element). Use reference objects of known size (bank card 85.6 x 54 mm, a coin, a wheel). Dimension lines sit outside the object. Scale from a photo: homography from known points. Track a line on a moving subject with a tracker; if error exceeds ~8 px (stable) / ~15 px (shaky chase) at 1080 wide, use a HUD figure instead of a line. A line that slides off the subject reads as lazy keyframing.

## 8. Grading
- Look: defined by BRAND.md palette. General principle: one calm base, one restrained accent; never push colours toward orange/teal clichés; no sepia, glaze, fake VHS or grain as decoration. Animation sections must carry the footage's palette and grade (the clip decides, not a flat palette).
- Order: conform (fps, size, 709 tags, range) -> HLG/HDR tone-map -> primary (black/white point, white balance, contrast) -> shot-match (luminance and contrast before hue; one hero shot per piece, match the rest to it) -> look (shadows toward the base tone, highlights not warmer than neutral, saturation only where it carries) -> texture only on film and only with a job -> measure -> before/after sheet over the whole piece (e.g. 12 times). Check text contrast after grading.
- Saturation: grey flat clips -> `vibrance=intensity=0.30` (not `eq=saturation`, which makes reds plastic). Too much colour -> skin-safe red muting, not global desaturation (which gives flat grey paint).
- HLG chain that has worked (check on stills AND in motion):
  `zscale=tin=arib-std-b67:t=linear:npl=203,format=gbrpf32le,zscale=p=bt709,tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,eq=contrast=1.06:gamma=0.97,vibrance=intensity=0.30`
- Texture: grain replaces glow. Only on film, never over text, never on paper surfaces; 4-8 % opacity; stepped (12-24 fps, pre-seeded), never smooth drift; if visible in a thumbnail it is too much. Vignette <= 12 %, never pulsing. Banding after grading: go through `format=yuv420p10le` or add faint noise.
- Palette to cs-animation: sample one frame (asphalt, sky, shadow, highlight); ink = the clip's own shadow tone (4th-6th percentile), light = its highlight tone. Send hex values, black level and grain size with the source still. Test: footage -> animation -> footage with no jump in black level, saturation or grain on a 30 fps stripe.
- Measure, do not eyeball: `scripts/grade-measure.sh before.mp4 after.mp4` prints YAVG, SATAVG, YLOW/YHIGH, YMIN/YMAX (signalstats). Limits: YMAX < 250 (skin, reds, sky not clipped), blacks near the base tone and not crushed to 0 unless the content is genuinely black.
- Never: teal-and-orange, LUT stacked on LUT, a log-to-709 LUT on a 709 clip, saturation up to "pop", warmer skin to look healthy, gradients as decoration, colours outside the BRAND ramps, claims that the grade matches a film or camera, filter-catalogue looks.
- Review note format: `<timecode/shot>: <what is wrong> -> <what to change> - protect <skin/reds/logo/text>`. Bad: "make it pop". Good: "0.0-1.2 s W1: asphalt pulls yellow -> cool the shadows blue +0.03, keep the red kerb, do not touch vibrance".
- Deliver: `-pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709` on everything you encode (prevents colour shifts); intermediates crf 14. One heavy ffmpeg job at a time and never during a render.
