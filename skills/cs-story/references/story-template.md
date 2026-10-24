# STORY.md: template, structures, beat rules

Read before writing or revising a STORY.md.

## 1. What STORY.md is
- The locked story for ONE piece: premise, hook, beats, exact on-screen text and VO, numbers for FACTS. Binding for cs-review, cs-animation, cs-audio-edit.
- Lives in the piece's folder next to the build (for example `<work>/<piece-id>/STORY.md`).
- **All text for screen or VO is verbatim inside "...".** The builder copies; she never rewrites. `textcheck.py` only checks quoted text.
- **Not a build log.** A STORY.md that grows into 25 version notes about rigs and renders is useless to reviewers. Build notes belong in the builder's `motion.md`/README. You keep one line per story version under `## Version`.
- New story version = new `## Version` line + new sha256 in the message. After FACTS/TASTE pass it changes only through a new round.

## 2. Template (copy, fill, delete the hints)
```markdown
# <ID> "<working title>" · STORY
owner cs-story · length <s> s (brief) · VO yes/no · text layer: cards | cards + rail (default with VO)

## Version
- v1 <date>: first draft.

## Premise
- Viewer: a stranger in the niche who has never heard of the brand.
- What they know from their own life: <...>
- The question they get: <...>   · What they do not know: <...>
- Premise (one sentence): <...>
- Retell (what a stranger says after one viewing; must match the premise): <...>
- Problem (happens on screen 0-3 s): <...> · Answer/explanation: <...>
- Why the brand (one line, no capability claim beyond BRAND.md): <...>
- Search phrase (same in on-screen text 0-3 s, VO and caption line 1): <...>

## Hook
- Chosen: Frame 0: <...> | Text (in at <t> s): "..." | First sound/word: <...> · mechanism hook:<type>
- Reserve: <...>
- Ranking notes: <helper output or the reason you chose this>

## Explanation ladder (max 4 steps)
1. <step> -> the picture that shows it: <...>

## Beat sheet
| Beat | Time (s) | Picture (what happens, subject visible) | On-screen text (exact) | Hold: W/N -> s | VO (exact) | Number -> facts | But/therefore |
|---|---|---|---|---|---|---|---|
| Hook | 0.0-3.0 | | "..." | | "..." | | - |
| 1 | | | | | | | but ... / therefore ... |
| End card | | per BRAND.md end-card rule | per BRAND.md | >= 3.2 s with CTA | | - | - |

## Honesty label
- From 0.0 s, one neutral line where BRAND.md requires it (e.g. illustration / calculated example / prototype footage).

## Sound
- VO: yes/no (voice and recording belong to cs-audio-edit). Near-silence 0.3-0.75 s before the payoff at <t>.
- Real sound that carries content: <...> at <t>.
- Platform-library sound suggestion (if any): <style, no vocals, from 0:00>.

## Numbers for FACTS
- <number> = <formula/scenario: inputs, assumptions>

## Assets
- <things the story needs that do not exist yet>

## Cut
- <what you cut and why> (shows that one idea was chosen)

## Reason to send
- <reveal to confirm / surprise / something to keep>; CTA type: save | send | question | series

## Publishing
- Caption line 1 (draft) · hashtag set · alt-text suggestion · experiment: hook:<type>, control <post>
```

## 3. Structures (pick one; never the same as the previous post)
| Structure | Skeleton | When |
|---|---|---|
| **Problem -> solution** | 0-3 s it happens -> 3-8 s why, one number -> 8-15 s the answer shown -> end card | default for danger/problem topics |
| **Niche-question chain** (voice-over) | question to the niche -> the common mistake -> answer -> one number -> punchline -> end card | VO pieces; VO tells, does not read the screen |
| **Guess -> reveal** | inputs on screen by 2.5 s -> choices as buttons -> 0.3 s silence -> reveal before ~5 s | quizzes |
| **Myth corrected** | belief shown -> "but" -> what actually happens, shown | when the myth is real and common |
| **Hybrid** | real footage 2-4 s (hook) -> animation explains (line, axis, number) -> same moment replayed (payoff) -> end card | when suitable footage exists; animation takes the footage's palette and grade |
| **Data piece** | ONE large view at a time | numbers with "~"; caption states the source |
| **Moment / loop** | 8-15 s, one event, last frame crosses into frame 0 | when the idea is one picture |

Length follows the brief: typical 20-25 s, allowed 7-70 s (BRAND.md can narrow it); vary a lot. Fill the time with story, never stretch; a 10 s story is a 10 s piece.

## 4. Beat rules
1. **One idea.** If you cannot say the premise in one sentence there is no story yet.
2. **But or therefore, never "and then".** Each beat answers the question the previous beat raised. Cut test per line: it grips, teaches, or sets up the payoff; otherwise out.
3. **Show before you say.** Concrete before abstract. A number appears only when the viewer can see what it means.
4. **Explanation ladder max 4 steps**, each with an exact picture.
5. **No switch without a bridge** (calculated vs measured, scenario A vs B): add a bridge card.
6. **At most one analogy**, tied to how the product really works.
7. **Let the viewer guess before the reveal**, about a scenario with its inputs, never about the person on screen.
8. **Timing:** subject visible within 1 s; what the brand is by ~3 s; first point by ~7 s and payoff before ~8 s (the average viewer is gone by 8-10 s); the "but" turn at 40-50 % of the length; payoff before 60 %; at most ~5 s from last payoff to the end.
9. **No new idea after the payoff.** Let it stand >= ~2 s, then the end card.
10. **Same subject, same numbers in every beat.** A hook that says 24 and a later beat that says 30 slips through two gates.
11. **The brand's subject is visible in every beat.** A beat without it is not on-brand content.
12. **Vary the form, keep the identity.** Not the same big headline + white boxes + identical end card every time.

## 5. Typical story fixes from a taste reviewer (avoid before they see it)
- Same template as the previous piece: let the picture carry the hook.
- Two steps show the same thing: merge and save the seconds.
- A formula or jargon on screen: move to caption or drop; show one picture.
- Two numbers in one beat: one per picture.
- Abstract word in the hook not understood in 3 s: show it or use an everyday word.
- Physics or facts the audience will challenge: have FACTS pick realistic numbers or label explicitly.
- The ending implies a capability the product does not have: end card and last VO line state only what BRAND.md allows.
- A beat that holds >2 s without the subject changing: cut to ~2 s or let it keep moving.

## 6. Stickiness and reason to send
Check, do not force all of it. **Simple** (one core a smart 12-year-old can retell) · **Unexpected** (one surprise pointing at the core) · **Concrete** ("93 C for 3 minutes" beats "brew it hot and short") · **Credible** (number from a source the viewer can check) · **Emotional** (one person in one moment, not statistics) · **Story** (a real moment the viewer has been in).
**Reason to send:** a reveal to confirm ("What did you guess?"), something surprising, or something worth saving (a number held >= 2 s before the end card). Ask: who sends this to whom, and why? Without an answer the piece has a ceiling. The ask lives in the caption, never "send this" on screen. **Social currency:** the sender looks smart; sharing it without the brand visible is a failure, so the brand must be part of the story.
