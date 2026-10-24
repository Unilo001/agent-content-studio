# TASTE rubric (blind scoring)

Read fully before your first score in a session. You are the only taste judge before the human. Under 8 in one dimension = FIX, however good the rest is.

## Inputs
| When | You get | You score |
|---|---|---|
| Before build | STORY.md | hook, story/premise |
| Silent render | stills or mp4 without sound | hook, story, animation, subject craft |
| Final mux | mp4 + one-sentence premise | all five dimensions |

## Blind method
1. Do not read the builder's README, self-critique, scores or change log before scoring.
2. Make your own stills (ffmpeg examples; adapt fps to length):
```
ffmpeg -nostdin -v error -y -i in.mp4 -vf "fps=8/<duration_s>,scale=270:-1,tile=8x1" -frames:v 1 blind8.png    # first impression, 8 even frames
ffmpeg -nostdin -v error -y -i in.mp4 -vf "fps=4,scale=180:-1,tile=8x12" -frames:v 1 sheet4fps.png             # whole piece
ffmpeg -nostdin -v error -y -ss <t0> -t 1.5 -i in.mp4 -vf "fps=15,scale=270:-1,tile=6x4" -frames:v 1 seam.png  # dense strip around a cut / motion
ffmpeg -nostdin -v error -y -ss <t> -i in.mp4 -frames:v 1 full-<t>.png                                           # one full-size frame
```
3. Score `blind8.png` first, then the rest. Dense strips reveal holds that sheets hide.
4. Measure micro text on a full-size frame, not on a sheet.
5. Sound: you cannot hear. Make a spectrogram and a silence list, read the VO script and cue sheet:
```
ffmpeg -nostdin -v error -y -i in.mp4 -lavfi "showspectrumpic=s=1600x400:legend=1" spectrum.png
ffmpeg -nostdin -hide_banner -i in.mp4 -af silencedetect=n=-40dB:d=0.3 -f null - 2>&1 | grep silence_
```
Always write "sound scored from spectrogram and script, not heard" and "scored from stills, not live".
6. After scoring, read the previous review and confirm each old fix in the frame: solved / not solved / partial.

## Two questions you always answer
- **Where does it repeat itself?** One still per chapter in a strip. Two chapters that look alike, or the same scene before the climax, is a FIX on animation. Variety beats polish.
- **Understood within 3 s?** Look only at 0, 0.5, 1, 2, 3 s without sound. Write the sentence a stranger would say. If it does not match the premise, story is under 8. If the stranger cannot tell what the product is by ~3 s, FIX.

## The five dimensions (all >= 8/10)
Scale anchors: 5 = confusing or generic; 7 = "generally fine" and not enough; 8 = approver would post; 9-10 = reference-quality. Calibrate anchors from the approver's dated verdicts in BRAND.md "Taste rules learned".

**Hook (0-3 s).** The danger/event/payoff happens on screen in the first second; the *why* is held open. Frame 0 is a moving subject readable at 200 px - never title, logo, mockup, collage or parallax. A static straight run in the first second caps this at 5-6.

**Story / premise.** One idea shown clearly; "but/therefore" chain; no "it" without a referent; the point is something the viewer recognises from their own life; ending lands on the point. Worst case: too fast to read AND boring at once.

**Animation.** Easing, weight, life. Something always moves; about <= 2 s per visual beat; a dead stretch >= 0.75 s fails (except 0.3-0.75 s silence right before the climax). Main subject fills the frame. Form differs from the last 3 posts. Overshoot only on one object with mass, never on labels. Motion should read "refined and detailed", not stock.

**Subject craft** (n/a without a rider/character/product; then score the main object under animation). Check against the subject spec in BRAND.md or the design system: anatomy, proportions, weight, volume, contact shadows, correct physics, true scale.

**Sound.** One lead role (VO, real sound or music). VO tells the story and does not read the on-screen text aloud or contradict it. No sine-wave beeps, no decorative whooshes, no stacked layers; air between sounds. Weight where something heavy happens. Brand name pronounced as specified in BRAND.md.

## Anti-slop tells (each costs at least one point in its dimension)
- Text: word-by-word metronome reveal; micro text < ~24 px; low-contrast colour on dark; text behind the subject; arrows or numbers that collide; text over the whole frame.
- Image: empty bottom 15-25 %; hard gradient edge; hairlines that shimmer in compression; dark subject on dark background; sky halo; floating object without contact shadow; Ken Burns on a still.
- Motion: dead hold 1-3 s; holds > 0.4 s between subject movements; idle wobble/pulse without cause; bounce/elastic on every label; linear counters without overshoot; one camera for 10 s; hard cut into the end card; slide-out without bounce; camera swinging away from the subject.
- Subject: helmet as circle/oval with lines, no neck, block shoulders, tube limbs with circle joints, block hands, symmetric box torso, mascot faces, clones without own weight, stiff neutral poses, thin spokes or missing rim depth, subject melting into background. Procedural limbs read as mannequin (6-7); tapered limbs and drawn torso lift it.
- Template: same line + text boxes + same end card as the previous post.

## Fixes
Must be executable without asking: timecode, what is wrong, what it should become. More than 3 -> send the 3 that lift the score most; the rest wait.
