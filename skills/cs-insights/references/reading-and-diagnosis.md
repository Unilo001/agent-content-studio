# Reading posts and diagnosing them

## 1. How to read
- **Source:** the platform's own insights API/export through the project's read-only tool; never a screenshot from the human. Keep the raw JSON beside your insight file.
- **Fields to record** (names vary): reach, views, sends/shares, saves, likes, comments, average watch time, total watch time, skip rate. A carousel gives fewer (reach, likes, saves). Not available on most platforms: followers gained per post, profile visits, non-follower share, retention per second. Do not substitute guesses; write "not measured".
- **Age:** compute hours since posting in UTC and local time. 24 h and 72 h readings only count within +-6 h. A 24 h reading cannot be fetched backwards, so ask cs-orchestrator to schedule the reading when the slot is set.
- **Lengths:** note piece length; "average watch as % of length" is the comparison that survives different lengths.
- **Pitfalls:** time zones (the API is usually UTC), duplicate media ids after re-uploads, units (watch time in ms), cached values, a metric that disappears or changes name (record it as a method note).
- **Log every reading**, also non-experiments (hypothesis/knob/control as "-"): the log is the basis of the baseline.
- **Outputs per reading:** an insight file (numbers, flags, diagnosis), a line in the post log, a row in the experiment log. Append-only; never edit old rows.

## 2. Diagnosis table (same age; thresholds are defaults, tune to the account and write the new values at the top of this section)
| Symptom | Stage | What to check | Owner |
|---|---|---|---|
| skip >= 45 % at 24 h | the opening failed | is the event in frame 0? is the brand visible by 3 s? gap closed too early? | cs-story |
| average watch < 12 s or < 50 % of length | the middle | first point by ~7 s? dead stretch? payoff before 60 %? | cs-story + cs-animation |
| skip < 35 % but reach stuck, sends < 0.5 % of reach | no reason to send | who sends this to whom, and why? reveal, guess with 2-3 choices, surprise, something to keep? | cs-story |
| reach very low and likes/reach > 4 % | never left the warm audience | originality, account status | cs-orchestrator |
| reach falls on several pieces together | eligibility | reuse of the same image + sound, square re-cuts of old pieces, watermarks, text covering the whole frame | cs-orchestrator |
| reach >= 3x median | hit | follow-up within 48 h, pin it the same day | cs-orchestrator |
| many views, follower count flat | follow conversion | does the closing line promise a next episode? profile, bio, pinned pieces? | cs-orchestrator |
| not found in search | discoverability | search phrase in the first ~55 characters of the caption and on screen within 3 s | cs-story |

One piece is one observation. The table gives a flag and an owner, not a cause.

## 3. Levels and baseline
- Typical skip targets used as working goals (not platform numbers): ~45 % = failed, ~35 % = healthy, ~25 % = stretch. Small accounts often see much higher skip rates than the account's best pieces; compare with your own history first.
- Internal goals to start from: sends >= 0.5 % of reach within 48 h; average watch >= 12 s and >= 50 % of length.
- **Baseline:** median of the last 10 pieces at 24 h (script it). A hit is >= 3x median reach. State n when the baseline is thin (n < 5).
- Keep a short "state of the account" paragraph in each weekly report; it replaces the previous one.

## 4. What small data can and cannot say
- Spearman rho as a hint, never as proof. With many metrics tested at once, correct for multiple comparisons (divide 0.05 by the number of metrics).
- Control for confounds (for example real footage vs animation when judging quality) with partial correlation on ranks.
- Compare reach only for pieces older than ~70 h.
- State n and the evidence level on every claim: measured / correlation / hint / anecdote.
- Typical patterns that survive scrutiny in short-form accounts: skip rate tracks share watched (partly mechanical); shorter pieces have higher share watched; fast, sharp sound events per minute tend to track skip (hint); metrics like "event in the first second" are useless when almost every piece has one; posting time is noise until a slot has 10+ posts.
- When sources conflict, show both with date and strength. Never choose silently.
