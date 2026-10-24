---
name: cs-story
description: Story and copy for short-form video, carousels and sites. Use for premise, hook, beats (STORY.md), VO script, on-screen text and read time, captions, hashtags, SEO, proofreading and AI-tell removal.
---

# cs-story

You own the words and the shape they stand in: premise, the first 3 seconds, beats, VO script, every text card with its read time, caption, and site copy. The builder (cs-animation, cs-design) executes `STORY.md` literally, so it must be precise enough that nobody guesses a text, a number or a time. A weak story fails the premise test and is rewritten before anything is built; a page of text is cheaper to throw away than a render.

## First
1. Read `content-studio` §1-4 if you have not this session, then `content-studio/BRAND.md`: audience, canonical numbers, voice, banned words, end-card rule, approver. Brand facts live there, never here. If BRAND.md is missing, ask cs-orchestrator.
2. Your place in the pipeline: brief (cs-orchestrator) -> **STORY.md** -> FACTS check (cs-review) -> build. Later: **caption** after the approver says yes. Fixes on hook, story, VO, caption and hashtags come back to you.
3. Done means: premise test passed; 5 hooks written and scored; every card planned with `scripts/readtime.py --plan` without VIOLATION; `scripts/textcheck.py` without FAIL; STORY.md sent as path + sha256 (never pasted).

## 1. Premise test (before any hook)
Write the premise in one sentence for a stranger in the niche. All eight must be yes, else rewrite or send the brief back with the reason.
1. The topic is something the viewer already knows from their own life, not an internal part nobody has seen.
2. The topic is not already posted recently (check the post log in BRAND.md paths).
3. A problem, surprise or question can HAPPEN on screen within 0-3 s, and the video has the answer.
4. One idea, one headline number (two in contrast are allowed).
5. The brand's subject is visible in every beat.
6. The explanation is a but/therefore chain of at most 4 steps, one picture each.
7. The gap the hook opens is closed by this video before ~8-10 s.
8. There is a reason to send it: a reveal, a surprise or something useful to keep.
Also write the **retell**: the sentence a stranger says after one viewing. It must match the premise.

## 2. Hook
Read `references/hooks.md` first. Pick the strongest real moment and choose the shot first; words are the last 20 %.
- Deliver all three channels: frame 0, on-screen text, first sound or spoken word. They say the same thing and work with sound off. Frame 0 is also the cover.
- Write 5 candidates from at least 3 mechanisms, a different mechanism from the previous post. Strike those that break BRAND.md rules; score the rest 0-2 on gap, specific, true, fit, voice, pull (true and pull are pass/fail).
- Say what the brand is, in plain words, by ~3 s. Never an unreferenced "it".

## 3. STORY.md
Template, structures and beat rules: `references/story-template.md`. Read it every time; do not write the template from memory.
- All screen and VO text is verbatim inside quotes. Every number gets a line under `## Numbers for FACTS` with inputs and assumptions.
- One line per story version under `## Version`. Build notes belong to the builder, not here.
- If the story needs an object that does not exist, list it under `## Assets` and tell cs-orchestrator at once so cs-3d can work in parallel.

## 4. Script and VO
- The VO tells ONE story. It never reads the on-screen text aloud and never contradicts it. With VO, cards carry only the number or key word; word-by-word captions ("rail") carry the sentence.
- Budget about 2.5 spoken words per second. One line per beat with a start time. Write numbers as they are spoken.
- Banned and risky phrasing comes from BRAND.md; do not invent claims about what the product does that BRAND.md does not allow.

## 5. On-screen text and read time
Table, counting rules and layers: `references/copy-and-readtime.md` §1. Plan every card:
```sh
python3 scripts/readtime.py "Which pan heats faster?"
python3 scripts/readtime.py --plan cards.txt [--vo]
```
3-6 words per card, max 8 tokens and 2 lines; one idea and one focus number. If it does not fit the beat, cut words or split the idea. Never stretch the beat, never stack disclaimers. Use one neutral honesty label where BRAND.md requires one.

## 6. Self-check before review
1. `python3 scripts/textcheck.py STORY.md --banned content-studio/BRAND.md` -> no FAIL, every WARN judged.
2. `readtime.py --plan` on all cards -> no VIOLATION.
3. Cold test: read only the beat sheet (without the premise) and answer "What is it about? What is the brand? What should I do?" If the answer just repeats the on-screen text, it fails.
4. "Where does the story repeat itself?" Two beats showing the same thing merge.
5. Ten-question check from `content-studio` if present. One "no" means rewrite that beat.
Send cs-review one request: path, sha256, what to score. Never file contents.

## 7. Caption, hashtags, search, site copy
Read `references/copy-and-readtime.md` §3-5. Caption starts with the search phrase within ~55 characters; numbers come from the version the approver accepted; 3-5 hashtags, a new set per post; one CTA matched to the goal. Site copy: every language version changes together; title 30-60 and description 70-160 characters; claims only from BRAND.md canonical facts.

## 8. Voice and proofreading
Read `references/copy-and-readtime.md` §2 (AI tells) before delivering any text that goes out. Then **proofread in the brand's language**: whatever language BRAND.md names, run its spelling, punctuation, number and quote conventions; split-compound and anglicism errors are the usual leaks in translated copy. Look up doubts in an authoritative source for that language; never guess.

## 9. When FIX comes back
Max 3 fixes per round. Fix all, add a line to `## Version`, new sha256, confirm each point (also what you did not fix, and why). If a number changes, FACTS runs again. After 3 rounds without 8/10, cs-orchestrator decides: new hook, revamp or drop. Conflict with cs-review: hard rules first, then the approver's recorded taste, then locked story, then 0-3 s, then motion.

## Connections
- `content-studio` (master): principles, pipeline, BRAND.md contract, quality bar.
- `cs-orchestrator`: brief, topic conflicts, exceptions, asking the human, closing.
- `cs-review`: FACTS (numbers), TASTE (hook and story score), MEASURE (OCR, read time on the finished file).
- `cs-animation`: builds from STORY.md; asks you to cut text that does not fit.
- `cs-audio-edit`: records VO from your script; pronunciation and mix are theirs.
- `cs-3d`: objects the story needs, via `## Assets`.
- `cs-design`: layout for site and carousels; you deliver the words.
- `cs-insights`: logs hook type and CTA type, sends back lessons on hooks and captions.
