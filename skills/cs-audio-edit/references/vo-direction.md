# Voice-over: script, direction, generation, transcript check

## 1. Does the piece have VO?
The brief decides. Typically not: quiz formats, pieces where rolling numbers carry the story, platform-sound variants, pieces with consenting people speaking on camera, carousels. With VO, on-screen text is <= 3 words or one number per card, and the on-screen rail (if the format has one) equals the VO word for word.

## 2. Script: cs-story owns the words, you own how they sound
- You may change spelling for pronunciation, numbers written as words, and pause marks. Changing meaning, order or a number goes back to cs-story (and cs-review FACTS for numbers). Every figure spoken must exist in facts.md.
- Spoken structure that works: question to the niche -> the common mistake -> the answer -> one number -> punchline -> CTA. The VO tells the story; it never reads the on-screen text aloud and never contradicts it.
- Speakable: <= 15 words per sentence, one idea each, contractions, numbers as words ("twenty-eight degrees"), "about" before computed figures. Banned words from BRAND.md apply in audio too.
- The product name is said once per piece. If the name is hard to pronounce for the voice, solve it by spelling it phonetically in the TTS text (hyphenate), never by switching models; keep a pronunciation dictionary alias if the service supports it.
- Length: ~2.5 words/s before tempo change, ~2.8 after +12 % tempo. The line must fit its beat with 0.2 s of air before and after. If it does not fit: shorter text (ask cs-story), never faster delivery.

## 3. Direction in text
Text-to-speech models usually take no style or speed parameter you can trust. Give intention, not intonation: write the line as a person would say it to a friend after the activity, not as an advert. "Go up at the end" does not work; context in the text does. Punctuation steers: ellipsis = pause, full stop = lower, question mark = lift; CAPS on one word at most for stress. Audio tags may not move the accent. You cannot hear: transcript + duration per line + spectrogram are your evidence; a human decides how it sounds.

## 4. Voice and settings
Voice, model and settings are project facts: see BRAND.md (voice id or name, model, language code). Defaults that have worked with ElevenLabs-class services: newest multilingual model, stability ~0.5, similarity ~0.75, style 0, output with timestamps (gives word alignment for `timing.json`), +12 % tempo in ffmpeg (`atempo=1.12`; over 1.2 only exceptionally, never on the name line). No stock voice if the brand has its own.
- **Voice cloning** of a real person only with that person's explicit yes on record, and via the orchestrator. Whether AI voice is disclosed is a BRAND.md decision, not yours.
- Generation is a `generation_access` question: voice switch off = no calls; write the script, tags and settings for the human instead.

## 5. Budget and discipline
No generation without the orchestrator's go for this piece. State the budget before running (characters in all lines x the service's rate, plus transcription). One take per line; at most two take-sets per piece; no broad searching across voices or variants. Account counters lag: compute from character count or response headers. Secrets: never write an API key to a file, log or message; do not name a variable `key` in an exec script.

## 6. Run
Keep one small script in `audio/` that takes a dict of line number -> text, calls TTS with timestamps, saves `vo_<n>_t<k>.mp3` + `.align.json`, then runs the transcription check and saves `transcript_<n>_t<k>.json`; the take number auto-increments and nothing is overwritten. Run it outside a sandbox that blocks network.

## 7. Transcript check of every take (before the mix)
Compare the transcript text to the script line:
- Doubled words, repeats or cut-off words = new take (within budget) or FIX.
- Numbers come back as digits: compare against a number-to-words table, not as text.
- Product and brand names are often transcribed wrongly; the name check then fails nearly always. Accept the take manually if the rest matches and write "pronunciation not heard" in SOUND.md; the human decides by ear.
- Transcribers invent `[music]` or `[bell]` tags in a finished VO mix even when the source is clean: check each line before mixing, not the mix.
- Pass a keyterms/prompt list for the name if the transcriber supports it.

## 8. VO in the mix
- One line = one file, placed with `adelay` from `cues.json`. Trim silence at both ends (`silenceremove`), so the 0.2 s air is yours.
- After tempo change, check that start + duration ends before the next line starts; a gap under 60 ms is a WARN.
- `timing.json`: `{id, start, end, text}` per line in piece time (the reviewer measures VO margin in these windows). Spell the name correctly there and in captions.
- Captions/word-pop are per sentence, not per word.

## 9. New voice or clone
Needs the approver's explicit yes via the orchestrator. Accent traits are not fixed by remixing, settings or tags. A clean 1-2 min recording of the person alone is enough for instant cloning; longer professional clones are a spending decision for the approver. Never delete voices you did not create.
