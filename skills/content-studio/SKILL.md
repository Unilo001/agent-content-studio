---
name: content-studio
description: Master skill for short-form video, carousels and website content made by agent teams. Every content agent reads §1-4 before work - principles, pipeline, brand-file contract, quality system - then loads exactly one role skill.
---

# content-studio (master)

Read §1-4 once per session, before opening your role skill. §5 routes you to that role skill. Brand facts never live here: they live in the project's `content-studio/BRAND.md` (§3). If BRAND.md contradicts this file on a brand fact, BRAND.md wins. If the project ships its own brand-specific content skills, those win over the generic ones.

## §1 Principles

In priority order:
1. **One idea, shown clearly.** Each claim is visible on screen before the next arrives. Fewer cards, not faster cards. Test: a stranger states the point in one sentence after one viewing, and it matches the premise. If not, rewrite the story before polishing anything.
2. **Frame 0 is an event.** The subject is already in motion, sound starts at 0.0 s. The danger, surprise or payoff must *happen* on screen, not be hinted at with a number or a title. Never open on a title, logo, mockup or slow parallax.
3. **Write for someone who has never heard of the product.** Say what it is in plain words within ~3 s. Never use "it" without a referent. Name first, mechanism second; tie analogies to how the product really works.
4. **Every beat is "but" or "therefore", never "and then".** Let the viewer guess before the answer when a guess is possible.
5. **Tempo is motion, not more cards.** Something moves all the time; text gets full read time; the payoff gets to stand. "Too fast to read AND boring" is the worst combination.
6. **End on the point.** No new idea after the payoff. Give a reason to send or save (answer, surprise, usefulness) - never write "send this".
7. **Vary the form, keep the identity.** Never the same template twice in a row. Logo, labelling and tone stay fixed; technique, camera, layers, timing and type motion change.
8. **Fill the frame.** The main subject fills the canvas; empty areas and empty seconds cost points.
9. **Honest by default.** Numbers come from a computed source and are labelled as illustration when they are. Never state in present tense what an unfinished product does. Compiled, simulated or rendered is never "tested". See BRAND.md for the exact banned claims.
10. **Quality over quantity.** Few, deeply made pieces beat volume. A queue that is empty is better than one filled with weak work.

Mechanism, evidence and exceptions: `references/principles.md`. Source strength: `references/sources-evidence.md`.

## §2 Pipeline

brief -> STORY -> FACTS check -> design / 3D / footage -> animation build -> stills TASTE check -> sound mix -> final TASTE + MEASURE -> approver -> post -> insights (+24 h / +72 h) -> lessons back into skills and BRAND.md.

| # | Step | Owner skill | Delivers | Gate before next step |
|---|---|---|---|---|
| 1 | Brief | cs-orchestrator | brief per `cs-orchestrator/references/brief-template.md` | topic not already used; form differs from the last 3 posts |
| 2 | Story | cs-story | STORY.md: premise, hook, beats, script, on-screen text | TASTE on story >= 8 |
| 3 | Facts | cs-review (FACTS) | facts.md: every number and claim checked | PASS before any build |
| 4 | Assets | cs-3d, cs-design, cs-audio-edit | 3D models, stills, footage (parallel with 2-3) | registered, scale and licence checked |
| 5 | Build | cs-animation | motion.md, build, silent render, self-critique | own score >= 8 per beat |
| 5b | Picture check | cs-review (TASTE) | scores from stills of the silent render | all dimensions >= 8 before sound is made |
| 6 | Sound | cs-audio-edit | grade, VO, real sound, mix, master, mux | cue times measured from frames, not from the builder's claims |
| 7 | Final check | cs-review (TASTE + MEASURE) | score report, measurement report | all >= 8 and MEASURE PASS |
| 8 | Approval | cs-orchestrator | contact sheet, file in the approver's folder, one question card | approver says yes per piece |
| 9 | Post | cs-orchestrator (+ cs-story for caption) | scheduled or posted per BRAND.md rules | never before the QA answer |
| 10 | Insights | cs-insights | +24 h / +72 h reading, experiment log | lessons sent to owners |

Websites and carousels: orchestrator -> cs-design -> cs-animation / cs-3d / cs-story as needed -> cs-review (MEASURE incl. accessibility and performance) -> deploy.

Handover rules: address agents by full id; send file paths and sha256, never file contents; every version gets a new filename (never overwrite a delivered file); the receiver checks the sha before measuring; `done` and `inform` messages are never answered.

## §3 Brand-file contract

Path: `content-studio/BRAND.md` in the user's project root (template: `templates/BRAND.md`). Agents read it at session start. Missing file = ask the orchestrator; do not invent brand facts.

BRAND.md must contain:
- **Product one-liner** and what may be claimed in present tense
- **Audience** and where they watch (platforms, sound on/off)
- **Canonical numbers** with their source (file or formula), rounding and labelling rules
- **Voice**: tone, language, reading level, examples of good and bad lines
- **Banned words** (heading `## Banned words`, one word or phrase per bullet; read by `cs-review/scripts/banned_words.py`) and banned topics
- **Palette and type tokens**, or a pointer to the design system; logo files
- **End-card rule**: what closes every piece, minimum hold time
- **Approver** and exactly what needs approval (every post? brand changes? money?)
- **Asset folders**: footage, 3D, fonts, logos, approved-people list and consent rules
- **generation_access**: switches per generator (`3d: on|off`, `image: on|off`, `voice: on|off`). Off means order packages for the human, never call the tool
- **Posting rules**: slots, daily cap, minimum gap, queue file
- **Taste rules learned**: dated quotes from the approver, newest first

Override rule: newest dated approver instruction wins over everything. Hard rules (honesty, consent, banned claims) win over taste. Lessons are written to BRAND.md by the orchestrator, not by workers.

## §4 Quality system

Three modes in `cs-review`: FACTS (before build), TASTE (scores), MEASURE (technical checks). Process:
1. Owner self-checks before delivering: one still per beat, fix anything under 8, run the ten questions in `references/principles.md` on the script.
2. Cheap pre-check first (scripts, regex, word lists), then the expensive taste review.
3. Anything under 8/10 in any dimension, or any FIX, goes back to its owner. The human only sees passed work.
4. Max 3 fixes per round, most valuable first, each with timecode, what is wrong, and the target. Max 2 internal rounds; then the orchestrator decides: ship the best version, new hook, rework, or drop.
5. Score from stills you made yourself, never from the builder's claims or a change log.
6. Only the orchestrator may accept a known tool artefact as a warning; reviewers never grant exceptions.
7. Conflict order: hard rules and honesty, then the approver's own words, then the locked story, then the first 3 s, then motion and craft.

Evidence before claims: "pass", "fixed" or "done" requires the command run this turn on this file hash. Audio that was only measured is "measured, not heard". Never write "should", "seems", "probably" in a verdict.

## §5 Routing

Each agent loads this file plus exactly one role skill. Need something else? Ask its owner; do not load another role skill.

| Skill | Load when |
|---|---|
| cs-orchestrator | brief, dispatch, model choice, gates, asking the human, queue, closing |
| cs-story | premise, hook, beats, script, on-screen text, read time, captions, SEO, proofreading |
| cs-animation | motion.md, HTML/GSAP/HyperFrames/canvas/Three.js builds, render, versioning |
| cs-3d | finding, coding, ordering or generating 3D assets; intake, scale, registration |
| cs-design | site, carousels, stills, palette and type decisions, pixel review |
| cs-audio-edit | footage intake, cut rhythm, grading, VO, real sound, mix, master, mux |
| cs-review | FACTS / TASTE / MEASURE before the human sees anything |
| cs-insights | reading results, experiments, teardown of viral posts, trends, lessons |

## Connections
- cs-orchestrator: briefs you, receives your delivery, owns every exception and every question to the human.
- cs-story, cs-animation, cs-3d, cs-design, cs-audio-edit, cs-insights: the role skills in §5; each starts with this file.
- cs-review: the gates in §4; fixes go back to the owner named in its report.
- `templates/BRAND.md`: the brand-file template (§3).
- Optional general skills: a design-reference skill before any visual choice, a verification-before-completion skill, a research skill.
