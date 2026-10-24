# Read time, voice and AI tells, caption and SEO, site copy

## 1. Read time (single canonical table; `scripts/readtime.py` implements it)
**Counting.** W = space-separated tokens with a letter or digit (numbers, units and URLs count; `25 km/h` = 2; pure punctuation does not). N = numeric values (a number counts in W and adds the N surcharge). Hold = from fully readable to exit start; in/out animation (<= 0.3 s) comes on top. Everything on screen at once counts together. New text on a standing card gets its own budget. Honesty labels and subject labels are not hook words.

| Card | Minimum hold | Word limit | Where and when |
|---|---|---|---|
| Hook text (frame 0) | max(chars / 20, 2.0) s, ideally ~3 s, stays through cuts | <= 6 main words, <= 12 total | in at 0.3-1.0 s, upper part, subject below, never behind text |
| Brand tag / ID line | label formula | as short as possible | from ~1.0 s, >= 44 px, readable by ~3.2 s |
| Explain card | max(1.8, 0.75 + 0.40 W + 0.50 N) s | aim 3-6, max 8 tokens, 2 lines | one idea, one focus number |
| Label over a self-explaining picture | max(1.2, 0.35 W + 0.5) + 0.5 N; +1.0 s if it must be tied to something in frame | 1-4 words | inputs go here, not on the explain card |
| Card under VO | same as its kind | <= 3 words or one number | the number or key word, not the VO sentence |
| Rail (word-by-word VO text) | per finished sentence | groups of 2-4 words, one line | uneven timing by meaning; in safe zone; never the same band as a card |
| Number ticker | landed value >= 0.6-0.8 s | fixed layout, only the digits change | not a card |
| Payoff card | explain formula, stands >= ~2 s with no new ideas | one number (two in contrast) | 0.3-0.75 s near-silence before |
| Product card | >= 2.0 s | one plain sentence | before the end card, product at true scale |
| End card | logo >= 1.8 s; with CTA >= 3.2 s | per BRAND.md | every video ends the same way |

**Always plan against the larger of the formula and `W / 3 + 0.6`.**
- **Cap:** no static text longer than ~2x its floor unless something new moves. Over-long text is re-read and bores.
- **Density:** a new card at the earliest 1.4 s after the previous started; at most 6 cards in a rolling 15 s window. Fewer cards, not faster cards. A card under 1 s is flicker and counts as unread.
- **Text swap on a cut** is fine. Text fade <= 0.08 s; longer fades ghost on contact sheets.
- **Too much text for the beat:** cut words or split the idea. More hold time does not fix clutter.
- **Three layers, three clocks.** "Too fast to read AND boring" is the worst combination; separate the layers instead of choosing one. Picture: about 2 s per visual beat, something always moves, a new beat is a real change (new angle, match cut, growing value, ring round a number, punch-in), not a shake or flash. Text: one card at a time at full read time, may span 1-2 picture beats. Numbers: landed value >= 0.6-0.8 s. Sound: cs-audio-edit (no hit per text card; near-silence before the payoff).
- **Word-by-word rail** is the default for VO pieces; dropped: filler words, stammers, self-corrections. Rail goes in the safe zone, in groups not blocks. **Emphasis word:** one word or number per beat may go big (never two at once, at least one beat apart, one apex = the payoff).
- **Overlay, not band:** text sits on the picture; never shove the main picture up to "make room".
- The sizes and safe zones are BRAND.md / cs-design territory; MEASURE checks the finished file.
Evidence limit: these are house heuristics, not measured comprehension. Adult reading of non-fiction runs ~4 words/s and subtitle practice caps ~20 characters/s; neither validates exact reel numbers.

## 2. Voice and AI tells
Order for each text: draft -> AI tells -> brand voice (BRAND.md) -> proofread in the brand's language -> `textcheck.py`.

**Voice (defaults; BRAND.md overrides).** One person talking to a peer; positive, simple, concrete; "you" and everyday verbs, not "utilisation". Say what the product shows, never lists of what it cannot do. One idea per text; show a number once, rounded on screen, exact only in the caption. Vary honesty wording from post to post (a repeated footnote 50 times reads as boilerplate). Closing line used in at most 1 of 4-5 pieces and never in both video and caption. No italics, emoji, exclamation marks, hype ("game-changer", "unlock"), or ALL-CAPS labels on everything.

**Caption/on-screen rules from an audit of ~75 captions:** 1. First sentence is what a rider would say to a friend: a question OR a number. 2. Vary structure (not hook-explain-brand-footnote every time). 3. Brand line in at most 1 of 4 posts. 4. No triplets of equal-length sentences. 5. No aphorisms ("less than you think"); say the number. 6. At most one percentage/model number beyond the hook, max 3 numbers in the body; over-precise numbers read as a report. 7. Honesty line is a real sentence, one per post. 8. No dashes as connectors; colon, full stop or comma. 9. Each beat says something new. 10. Two captions in a batch never share an opening or ending.

**AI tells (strongest first; fix on first hit):**
1. "not X but Y" / "it's not X, it's Y" (also split over two sentences, or the tail ", no guessing") -> say the point; contrast only when the reader really believes X.
2. One-line dramatic closers ("Let that sink in.", "Every. Single. Day.") -> cut or make it a fact.
3. Deep sayings ("at its core", "the real question is") -> the concrete claim.
4. Warm-ups ("Let's dive in", "Here's the thing", "Honestly?") -> start with the point.
5. Arguing with nobody ("To be clear", "You might think... but") -> remove the defence.
6. Forced triads -> three items only when the meaning has three.
7. Same sentence opening several times -> merge or start with the action.
8. Em/en dashes as connectors -> full stop, comma, colon, parentheses.
9. Stacked hedges ("could potentially") -> one hedge if the source requires it.
10. Compound adjectives after the noun ("is high-quality") -> "is high quality".
11. Passive or missing subject -> active.
12. AI vocabulary (actually, additionally, crucial, delve, pivotal, robust, showcase, tapestry, testament, vibrant, landscape (abstract), meticulous, intricate, underscore, enhance) -> plain words.
13. Inflated significance ("stands as a testament") -> end on the last concrete fact.
14. Vague links ("associated with") -> say what relates to what.
15. Shallow -ing tails (", ensuring nothing slips") -> own sentence or cut.
16. Sales gloss (breathtaking, must-see) -> describe what is there.
17. Borrowed authority ("experts say") -> a named source or cut.
18. Avoiding "is/has" ("serves as", "boasts") -> "is", "has".
19. Bold as decoration; bold-label lists -> prose. 20. Title Case headings, emoji, arrows -> sentence case.
21. Chatbot leftovers ("Great question!", "I hope this helps") -> delete.
22. Writing about the document instead of the subject ("the table below compares") -> write about the subject.
Also: self-answered questions ("The result? 3x faster."), colon reveals ("The best part: it learns."), stock phrases ("Say goodbye to"), negation lists ("No X, no Y, no Z"). Cap: one fragment and one triad per section. If a fact is missing write `[NEEDED: ...]`; never invent.
**Do not touch:** quotes, proper names, numbers and facts, the approver's own wording. Never remove a fact for rhythm.
**Make it human:** start from one real moment; vary sentence length (one fragment is fine if it carries a fact); one detail only someone in the niche would know, and only if true in the footage; read it aloud: if it sounds like a poster, rewrite.
**Final check:** re-search tells 1, 2, 6, 8, 19; confirm no facts fell out; run `textcheck.py`.

## 3. Captions
- Plain-text file the posting tool publishes whole: no titles, no notes, no "ALT:" or "FILES:" lines. Sound suggestion, alt text and experiment notes go in STORY.md `## Publishing` and in the message to cs-orchestrator.
- **Numbers = the numbers of the version the approver accepted.** Take them from the FACTS file and check against stills of the approved render; stale numbers from an earlier cut are the usual bug.
- Decide the search phrase in STORY.md so it is also in the on-screen text 0-3 s and in the VO. Write the caption after the approver's yes.
- Template (<= ~300 characters and < 50 words before hashtags): line 1 = search phrase within ~55 characters (whole line <= 125), a question or one number; 1-2 sentences saying what happens with the numbers; one neutral honesty line if BRAND.md requires one; the brand line from BRAND.md; 3-5 hashtags.
- One CTA matched to the goal: save ("Save it for your next ride"), send (relational, tied to the conclusion), open question ("What did you guess?"), next in series. Never "comment WORD", "like if", "tag 3 friends".
- **Hashtags:** 3-5 unique, never more; a new set per post; at least one niche tag and the brand tag; never #viral #fyp #reels #explore; mega-tags add little; spend 10 s on them at most.
- Run the brand's caption checks (BRAND.md) and `textcheck.py` before handing over. Under platform length limits (2,200 characters on Instagram).

## 4. Search (the platform is a search engine)
- Keywords live in content, caption, bio and hashtags; search also reads picture and audio.
- **Same phrase in three places:** on-screen text in the first 3 s, VO, caption line 1. One piece, one phrase.
- Find the phrase in real search: captions and on-screen text of the top-5 posts on the topic, "People also ask". Never invent search volume. No keyword stuffing; the caption must be about what the picture shows.
- Account name field and bio are brand decisions: propose via cs-orchestrator, do not change.
- For alt text where the API cannot set it, put a suggestion in STORY.md.

## 5. Site copy and carousels
- All language versions change together; check structure (titles, headings, hreflang) with the project's checks.
- Title 30-60 and meta description 70-160 characters, one H1, canonical URL; keep existing URLs.
- Honesty: claims only from BRAND.md canonical facts; status words (in development, prototype) exactly as BRAND.md. Numbers from the same source as the video.
- Three passes before delivery: clarity (one point per paragraph, no unclear pronouns), "so what?" (each feature says what it means for the reader), proof and precision (numbers sourced; "Save time" becomes a number or is cut).
- Buttons and error messages: verb first, specific. Long compound words in the target language must wrap cleanly on a 390 px screen (cs-design).
- Glossary pages: one term per entry, explained with a concrete picture or number.
- Carousels: layout is cs-design's; text is yours. Cover = the hook (promises the swipe, readable as a thumbnail); one idea per slide; numbers with the same marking as video; same caption rules.
- Full technical SEO audit: use an SEO-audit skill if installed.

## 6. Proofreading in the brand's language
Read the language and register from BRAND.md. Check, in order: spelling standard (variant), compound/hyphenation rules, punctuation (commas, quotes, decimal and thousands separators, percent spacing, dates, times), number style (words vs digits), agreement and word-order slips, false friends and anglicisms from translated sources. When translating: translate by what the text must DO (explain, instruct, reassure), not word by word; never translate code, paths, URLs, version numbers or product names; length typically moves +-20 %; ask once if something is untranslatable and offer two options; end with "Would a native writer start the sentence this way?". Consult an authoritative reference for that language for any doubt; never guess.
