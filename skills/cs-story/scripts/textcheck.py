#!/usr/bin/env python3
"""textcheck.py: cheap lint for copy before review. Python 3 stdlib only.

  python3 textcheck.py STORY.md|caption.md [--banned content-studio/BRAND.md]

Checks text inside curly or straight double quotes if any exist (STORY.md), else the whole file:
  FAIL  banned words from BRAND.md (section 'Banned words / phrases', one per line)
  FAIL  emoji, exclamation marks
  WARN  dashes used as connectors, AI-tell words, 'not X but Y' frames, triads, stacked hedges
Exit 1 on FAIL. WARN needs human judgement. This is a lint, not a verdict.
"""
import argparse
import re
import sys

AI_WORDS = ("actually additionally delve tapestry testament pivotal robust meticulous intricate "
            "showcase underscore bolstered vibrant landscape crucial enhance garner seamless "
            "game-changer unlock supercharge").split()
FRAMES = [r"\bnot (?:just )?[\w' -]{1,30}[,;]? but\b", r"\bit'?s not [\w' -]{1,30}, it'?s\b",
          r"\blet'?s dive in\b", r"\bhere'?s the thing\b", r"\blet that sink in\b", r"\bat its core\b",
          r"\bthe real question\b", r"\bcould potentially\b", r"\bmight arguably\b"]
EMOJI = re.compile("[\U0001F300-\U0001FAFF☀-➿]")


def banned_from(path):
    out, on = [], False
    for line in open(path, encoding="utf-8"):
        if line.startswith("#"):
            on = "banned" in line.lower()
            continue
        m = re.match(r"\s*-\s*(?:Banned[^:]*:)?\s*(.+)", line)
        if on and m and m.group(1).strip() and "(" not in m.group(1)[:1]:
            out += [w.strip().lower() for w in re.split(r"[,;]", m.group(1)) if w.strip()]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("--banned")
    a = ap.parse_args()
    raw = open(a.file, encoding="utf-8").read()
    quoted = re.findall(r"[“\"]([^”\"\n]{2,})[”\"]", raw)
    text = "\n".join(quoted) if quoted else raw
    low = text.lower().replace("\u2019", "'")
    fails, warns = [], []
    if a.banned:
        for w in banned_from(a.banned):
            if re.search(r"\b" + re.escape(w) + r"\b", low):
                fails.append("banned word/phrase: " + w)
    if EMOJI.search(text):
        fails.append("emoji")
    if "!" in text:
        fails.append("exclamation mark")
    if re.search(r"—|–(?!\d)| -- ", text):
        warns.append("dash used as connector: use a full stop, comma or colon")
    for w in AI_WORDS:
        if re.search(r"\b" + w + r"\b", low):
            warns.append("AI-tell word: " + w)
    for pat in FRAMES:
        if re.search(pat, low):
            warns.append("AI-tell frame: " + pat)
    if re.search(r"\b\w+, \w+(?: \w+)?,? and \w+(?: \w+)?\.", text):
        warns.append("possible forced triad: use three items only if the meaning has three")
    for f in fails:
        print("FAIL " + f)
    for w in warns:
        print("WARN " + w)
    print("%d FAIL, %d WARN" % (len(fails), len(warns)))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
