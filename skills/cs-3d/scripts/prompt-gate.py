#!/usr/bin/env python3
"""prompt-gate.py: cheap regex gate for generator prompts, before any human or model sees them.
Stops text/logo/number requests, minors, brand-like wording from a banned list, and flags human figures.
Lines starting with Avoid:/Negative: and block headers (===) are skipped.

  python3 -I prompt-gate.py image-prompts.txt [--banned BRAND.md|words.txt]   (or "-" for stdin)

--banned: a file with banned words/phrases, one per line, or a BRAND.md with a "## Banned words" section
(bullet lines). Real brand and person names cannot be listed here: add the ones relevant to your niche
to that list and always look at the prompt yourself.
Exit 0 PASS, 1 FAIL (rewrite), 3 PERSON (human figure: the approver must say yes first), 2 usage.
"""
import re, sys

LOGO_TEXT = r"logos?|wordmark|brand(ed|ing)?|lettering|text|typography|letters|words|slogan|caption|number ?plate|licen[cs]e plate|race number|bib number|start number|sponsor|watermark|trademark"
CHILD = r"child|children|kids?|boy|girl|baby|toddler|teen(ager)?|school ?kid"
HUMAN = r"person|people|man|woman|men|women|human|humanoid|figure|character|rider|cyclist|athlete|pedestrian|mannequin|face|hands?"
CELEB = r"celebrity|famous|lookalike|look-alike|portrait of|in the style of [a-z]+ [a-z]+"
SKIP = re.compile(r"^\s*(avoid|negative|negative prompt)\s*:", re.I)
NEG = re.compile(r"\b(no|without|never|not)\s+(any\s+|a\s+|an\s+|the\s+)?[a-z'\-]+(\s*(,|or|and|/)\s*(no\s+)?[a-z'\-]+)*", re.I)

def rx(s):
    return re.compile(r"\b(" + s + r")\b", re.I)

def banned_words(path):
    if not path:
        return []
    words, inside = [], False
    text = open(path, encoding="utf-8").read()
    if path.lower().endswith(".md"):
        for line in text.splitlines():
            if line.lstrip().startswith("#"):
                inside = line.strip("# ").strip().lower().startswith("banned words")
            elif inside and line.lstrip().startswith(("-", "*")):
                words.append(line.lstrip("-* ").strip())
    else:
        words = [l.strip() for l in text.splitlines() if l.strip() and not l.startswith("#")]
    return [re.escape(w) for w in words if w]

def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__.strip()); return 2
    src = a[0]
    bpath = a[a.index("--banned") + 1] if "--banned" in a else None
    text = sys.stdin.read() if src == "-" else open(src, encoding="utf-8").read()
    rules = [("FAIL", "logo/text/number in the image", rx(LOGO_TEXT)), ("FAIL", "minor", rx(CHILD)),
             ("FAIL", "real/famous person", rx(CELEB)), ("PERSON", "human figure", rx(HUMAN))]
    bw = banned_words(bpath)
    if bw:
        rules.append(("FAIL", "banned word (BRAND.md)", rx("|".join(bw))))
    hits = []
    lines = [l for l in text.splitlines() if not SKIP.match(l) and not l.startswith("===")]
    for nr, line in enumerate(lines, 1):
        line = NEG.sub(" ", line)
        for level, why, pat in rules:
            for m in pat.finditer(line):
                hits.append((level, why, m.group(0), nr))
    for level, why, word, nr in hits:
        print(f"{level}  {why}: \"{word}\" (line {nr})")
    if any(h[0] == "FAIL" for h in hits):
        print("=> FAIL: rewrite (describe shape/material/colour instead of names; no text or logos)."); return 1
    if hits:
        print("=> PERSON: human figures need the approver's yes (ask via the orchestrator); procedural figures are built in code."); return 3
    print("PASS regex. Now read the prompt yourself for real brand, place or person names."); return 0

if __name__ == "__main__":
    sys.exit(main())
