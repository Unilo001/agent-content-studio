# Experiments

Method adapted from fixed-budget, one-metric, keep-or-discard research loops. Goal: learn something that survives the next piece, without treating small numbers as proof. The master principles and BRAND.md always apply; an experiment never licenses breaking them.

## 1. Before the piece is made (brief or STORY.md)
All five must exist, else it is a piece, not an experiment:
1. **Hypothesis** with direction: "If X, then lower skip rate / more sends, because <mechanism>."
2. **Knob:** exactly one change against the control (hook type, length, ending form, sound strategy, amount of text, technique). Write it as `knob:value` (`hook:danger-first`, `length:40`, `ending:next-episode`, `sound:voiceover`, `technique:real-footage`) so the same type always has the same name; take hook types from STORY.md.
3. **Control:** a posted piece, same on everything else, with a reading at 24 h or 72 h (+-6 h) in the log. None = anecdote.
4. **Pre-registered row** in the experiment log before posting. Never rewrite the hypothesis after the numbers come in. A request that arrives after posting is registered retroactively and can only produce an anecdote.
5. **Variation rule:** the form still differs from the last three posts. The knob is the only deliberate same/different; technique and ending vary only if they are the knob, otherwise hold them equal to the control.
Also name a **guardrail**: a metric that must not get worse (typically skip when chasing sends).
Lesson learned the hard way: a batch of registered "experiments" taught nothing because each knob changed 2-5 things at once and controls were never read at the same age.

## 2. Reading
Read the piece and its control at the SAME age (24 h or 72 h; never mix windows within a pair). If the control only has today's numbers, mark it. Wrong age (beyond +-6 h): "skewed age" and do not use the row for comparison.

## 3. Metrics (one main metric, chosen in the hypothesis)
- **Skip rate** measures the hook. **Average watch time** measures the middle. **Sends and saves** measure the reason to send (0-4 per piece is noise).
- Followers per piece is rarely available; account follower count before and 48 h after is rough side information, never a result.
- 3-second hold is usually unavailable: use skip rate as the stand-in and say so.
- Secondary metrics are read but do not decide.

## 4. Anecdote, weak signal, signal (defaults; tune as the account grows and write the new values and why at the top)
- At reach near 1,400 and skip near 40 %, pure sampling noise is about +-1.3 percentage points, but the difference BETWEEN pieces is far larger and comes from content, timing and who was shown it. One pair can therefore never prove anything.
- **Anecdote** (always the default): one pair; reach < 1,000 on either; sends < 10 in total across the comparison; skewed age; several knobs changed; retroactive registration.
- **Weak signal:** same direction in >= 3 pieces with the knob against >= 3 controls, and skip-rate difference >= 8 pp (or average watch >= 25 % longer) in all three. Working hypothesis, not fact. If the main metric is sends or saves: >= 2x per 1,000 reach in each pair.
- **Signal:** weak signal confirmed in a new round with a different variant of the idea, or reach >= 5,000 per piece. Only then is default practice changed, by the owner of that practice.
- "No direction" is a valid outcome: test another variable, do not "try harder".

## 5. Decision
- **keep:** the knob becomes the default for the next piece's briefs (only at weak signal or better; you propose, cs-orchestrator decides).
- **discard:** the opposite direction in two pieces, or the knob hurt something else (skip, legibility, honesty).
- **try again:** anecdote. Plan a new piece with the same knob and a different control. Max three tries, then discard with the note "not measurable on this account".
No decision makes a piece "good" or "bad"; the approver's taste and rejections outrank the numbers.

## 6. Log
Tab-separated, UTF-8, append-only, you are the only writer. Columns:
`date · piece · hypothesis · changed_knob · control_piece · age_h_read · reach · skip_rate_pct · avg_watch_s · sends · saves · follower_delta_48h · result · decision · note`
- Four row types: (1) pre-registration (hypothesis, knob, control, decision=open, numbers empty); (2) reading at 24 h; (3) reading at 72 h (copy hypothesis/knob/control, result=anecdote); (4) a decision for a knob (piece=-).
- Empty cell = not measured. Decimal point, no units, no thousand separators. `result`: anecdote | weak_signal | signal. `decision`: keep | discard | try_again | open | -.
- Note keys, separated by `; `: `hm=<main metric>`, `gr=<guardrail>`, `slot=<date time>`, `length=<s>`, `hook=<type>`. A small script that writes rows and groups by exact knob text keeps tabs and numbers consistent; do not type tabs by hand.
