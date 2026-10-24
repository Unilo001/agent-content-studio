# BRAND.md — content-studio brand file

Copy this file to `content-studio/BRAND.md` in your project and fill it in.
Every content-studio skill reads it; brand facts never live in the skills themselves.

## Product
- One-liner (what it is, for whom, in ≤ 15 words):
- What it is NOT (common misreadings to avoid):
- Website / handle:

## Audience
- Primary viewer and what they already know:
- What makes them stop scrolling (pain, curiosity, identity):

## Canonical facts
Numbers and claims that must be quoted exactly (size, weight, price, specs, dates). cs-review checks every post against this list.
| Fact | Value | Source |
|---|---|---|

## Voice
- Language(s) and spelling standard:
- Tone in three words:
- Taglines in use:

## Banned words
One bullet per word or phrase. A trailing `*` matches as a prefix. cs-review's `banned_words.py` reads this list.
- 

## Visual system
- Pointer to design system or tokens (palette, fonts, logo files):
- End card rule (what every video ends with):
- Formats: 9:16 video length range, carousel size, site breakpoints:

## Approval
- Approver:
- Needs approval: (e.g. product depictions, real people, palette/logo changes, spending money)
- Runs autonomously: everything else
- Where to ask (issue tracker, chat, card system):

## Assets
- Footage folder:
- 3D register and asset folder:
- Order-package folder (for generators the agents cannot run):
- Inbox for human-generated results:

## Generation access
```json
{ "image_generator_auto": false, "model_generator_auto": false }
```
Only the human flips these. When false, agents write order packages instead.

## Posting
- Channels and schedule:
- Who presses publish:

## Taste rules learned from the approver
Append one dated line per verdict ("2026-10-24: too slow in the first 2 s; hook must show danger first").
