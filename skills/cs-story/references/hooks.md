# Hooks: mechanisms, scoring, ranking

Read before writing hook candidates. Brand-specific bans and wording live in `content-studio/BRAND.md`; the rules below are general.

## 1. Rules for every hook
- **The event happens on screen in 0-3 s.** A number or title that only hints at the problem is weaker than the problem itself. The answer or explanation comes afterwards.
- **Frame 0 is an event**: the subject in motion, readable at 200 px in 0.25 s. Not a title card, logo, mockup, collage or slow parallax intro; openings like these lose most viewers in the first seconds.
- **Three channels say the same thing**: frame 0, on-screen text, first sound or word. It must work with sound off.
- **Choose the shot first.** Changing only the wording of a hook barely moves results; changing what the viewer sees does.
- **Say what the brand is** in plain words by ~3 s. Never "it" without a referent.
- **A different mechanism from the previous post.** Log it as `hook:<type>` so cs-insights can compare.
- **Words in frame 0**: at most 6 main words, 12 in total; text in by 0.3-1.0 s, held ~3 s.
- **Banned in hooks**: fake suspense ("wait for it", hidden reveal, fake countdown, delayed payoff), filler events, abstract words the viewer cannot parse in 3 s (show it or use an everyday word), counters on real footage that look like automatic detection, ratios between angles/quantities that do not scale linearly, and anything BRAND.md bans.

## 2. Mechanisms
Write 5 candidates from at least 3. The mechanism matters, not the template.

| Mechanism | Shape | Typical failure |
|---|---|---|
| **Danger or problem that happens** (in media res) | the thing goes wrong in 0-2 s, caption names it | danger only implied by a number; real injury or crash |
| **Guess / choose** | two scenarios with their inputs, answer buttons, silence 0.3 s, reveal | choices as plain text (must look like buttons or a poll); guessing about the person on screen instead of a scenario |
| **Contrast number** | "10 % less, half the effect" with both values on screen | over-precise numbers; three numbers on one card |
| **Myth corrected** | the common belief shown, "but", what actually happens | claim without stakes; gap closed too early |
| **Question to the niche** | a concrete question the niche knows from experience | yes/no question; abstract word; no subject in frame |
| **Payoff first / rewind** | show the peak, rewind to how it happened | payoff reveals everything, nothing left to wonder |
| **Side-by-side in one scene** | two subjects or lines in ONE scene | split diagrams |
| **Sound first** (real recording) | the characteristic real sound at 0.2 s | synthetic sound; no visible subject |
| **Series** | a numbered episode on real footage, number visible 0-3 s and on the cover | series without a real episode behind it |
| **Scale / product** | the product in hand at true scale next to a known object | product too large; product opening without the subject |
| **Honest / anti-sales** | "Don't buy it yet. It isn't finished." | pessimism and lists of what it cannot do |

Not used: time pressure and FOMO with a fake clock, and authority without verifiable proof.

## 3. Score each candidate before ranking
**Gates (pass/fail, first):** true to what the video actually shows; no banned wording; numbers traceable to BRAND.md canonical facts or a FACTS line; the product exists for the viewer; the event can be shown.

**Rubric 0-2 per dimension:** Gap (opens a real hole a stranger must close) · Specific (a concrete number or detail) · True (the video delivers) · Fit (lands in 0-3 s, <= 6 main words) · Voice (matches BRAND.md) · Pull (read it cold: do you need the next beat?). **True and Pull are pass/fail.** Most hooks you write should die.

**Anchors for a 10-point taste scale:** ~9 = the event is on screen at 0 s with a clear premise without sound; ~8 = subject in motion, a concrete question or number from frame 0; 7 = tilted horizon or kerb in the opening without real stakes; 5-6 = a straight road at 0-1 s, a presentation ("MEET THE PRODUCT"), a question without stakes. Cap about 8 without a real event, and for animation without a real subject.

Common hook faults: brand tag missing in 0-3 s; tag inside the platform's top UI zone, under 44 px or abbreviated; label text too small; hook without the subject or a number; empty frame for ~1 s; cover number differs from the number in the video; same opening sequence in two posts; gap closed before 3 s.

## 4. Ranking the survivors
If a decision helper exists, give it each candidate in the same form (max ~40 words): `Frame 0: ... | Text (in at t s): "..." | First sound/word: ...` and the question "Which opening makes a stranger in the niche understand within 3 seconds, with sound off, what is happening, and need to see the next beat?". Read the probabilities, not only the winner. If confidence is low or the top two are close, choose yourself and write one line why. Without a helper, rank by the rubric and a cold read by someone who has not seen the premise. Send the chosen hook plus one reserve to cs-review.

## 5. What to take from other people's posts
Copy the mechanism, never the surface (sound, topic, format, script). One post is an anecdote, and the size of the account decides whether it can be repeated. Use cs-insights for a proper teardown.

## 6. What data can and cannot say
Small samples, correlation only. Treat any benchmark you did not measure yourself as a hint, not a rule. In the creator's own data the common pattern is: one clear event in the first second beats polish in the opening; but a danger hook with weak craft does not hold either, so quality must be there too. Never quote blog statistics ("shares weigh 3-5x likes", "80 % watch muted") as fact. cs-insights owns measurements; ask it for the current baseline.
