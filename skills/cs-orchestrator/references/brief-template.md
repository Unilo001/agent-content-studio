# Brief template (8 points)

Use for every worker and every larger request to a standing agent. Target 150-300 words plus paths. The receiver does not inherit the conversation.

## First lines (in this order)
1. Gate token if one is needed, first in the objective, quoting the human's exact words and date. Never invent one.
2. `The assignment here is the whole brief. Do not stop at doubt: choose the most conservative option and write the choice in the report.`
3. `SKILL: cs-<role> (mode <X>). Read <path>/cs-<role>/SKILL.md first; load no other content skill.`
4. `{ticket id} {title}. Done = <check> gives PASS.`

## The 8 points
1. **GOAL** - one sentence plus why (the human's dated ruling if one drives it).
2. **READ** - at most 3 files with line ranges (BRAND.md sections, the story file, the posted log). Not whole master files.
3. **DO** - numbered steps, pre-computed: numbers, times and paths decided by you, not by the receiver.
4. **AGREED EXCEPTIONS** - deviations from content-studio or BRAND.md that apply to this piece only (e.g. 40 s because the brief says so).
5. **BLOCKS** - no git mutations, push, posting, deploy, spending; write only to `<exact file list or folder>`; never overwrite an earlier version (new filename); one heavy render at a time.
6. **ACCEPT** - a runnable command with expected result (exit 0, PASS). `UNTESTABLE` only for a named item, with the reason.
7. **DELIVER** - report file path + at most 12 lines in the message: files with sha256, commands with exit codes, evidence level per claim (VISUALLY REVIEWED / SCRIPT-TESTED / COMPILED - never "tested" or "heard" unless it was). Max 2 internal fix rounds -> `READY` or `BLOCKED: <item>`. Send the done message to the orchestrator (and a request to the named reviewer if the brief says so).
8. **MODEL / BUDGET** - model and token cap; at the cap or a quota stop: write status to the report file, report once, stop.

## Rules for the author
- Positive target behaviour; prohibitions only as hard blocks in point 5.
- Each step ends on a checkable criterion.
- Point to BRAND.md for numbers; repeat only the one the receiver is judged on.
- Temporary workers without a worktree never run git checkout/switch/branch/stash/commit; say so.

## Example: story worker
```
The assignment here is the whole brief. Do not stop at doubt: choose the most conservative option and write the choice in the report.
SKILL: cs-story (mode STORY). Read <path>/cs-story/SKILL.md first; load no other content skill.
P-014 "Late apex". Done = STORY.md exists and the ranking of 5 hooks is in the report.
1 GOAL: premise + hook + beats + script for a 20-25 s piece about turning in too late. Why: danger first + solution carries views (approver, dated).
2 READ: pieces/p-014/BRIEF.md; posted-log (last 3 rows); BRAND.md "Voice".
3 DO: (1) write 5 hook candidates and rank them with the cheap triage tool. (2) write STORY.md from the cs-story template. (3) send STORY.md to the FACTS reviewer and the TASTE reviewer.
4 AGREED EXCEPTIONS: none.
5 BLOCKS: write only in pieces/p-014/; no git/posting/deploy.
6 ACCEPT: STORY.md has a one-sentence retell, timed beats, every number tagged for FACTS.
7 DELIVER: pieces/p-014/story-result.md, <= 12 lines to the orchestrator.
8 MODEL / BUDGET: strong writing model, token cap 1,000,000.
```
