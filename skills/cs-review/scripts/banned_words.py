#!/usr/bin/env python3
"""banned_words.py - generic banned-word checker (python3 stdlib only).

Usage:
  banned_words.py [--brand content-studio/BRAND.md] [--code] PATH [PATH ...]

Reads the list from the "## Banned words" section of BRAND.md: one word or
phrase per bullet ("- word" or "* word"); text after " - " or "(" on a bullet
is treated as a comment. Scans text files (.md .txt .srt .vtt .json .html .js
.mjs .css) in the given files/folders; with --code only string literals are
scanned in code files (.js .mjs .html .json). Whole-word, case-insensitive;
a trailing * on a bullet means prefix match (e.g. "measur*").

Output: file:line: WORD | text.  Exit 1 on any hit, 2 on usage/brand errors.
A hit is a finding, not a verdict: if the text is shown or spoken it is a FIX;
meta-text about the rule or dead code is ignorable - say why in the report.
"""
import argparse, os, re, sys

SKIP_DIRS = {"node_modules", "vendor", "out", "old", ".cache", ".git", "__pycache__"}
TEXT_EXT = {".md", ".txt", ".srt", ".vtt", ".json", ".html", ".js", ".mjs", ".css"}
CODE_EXT = {".js", ".mjs", ".html", ".json"}
STRING = re.compile(r"""(["'`])((?:\\.|(?!\1).){2,}?)\1""")


def load_words(brand):
    try:
        lines = open(brand, encoding="utf-8").read().splitlines()
    except OSError as e:
        sys.exit(f"cannot read brand file {brand}: {e}")
    words, inside = [], False
    for line in lines:
        if re.match(r"^#{1,6}\s+banned words\b", line, re.I):
            inside = True
            continue
        if inside and re.match(r"^#{1,6}\s", line):
            break
        m = re.match(r"^\s*[-*]\s+(.+?)\s*$", line) if inside else None
        if m:
            w = re.split(r"\s+-\s+|\s*\(", m.group(1))[0].strip().strip("`\"'")
            if w:
                words.append(w)
    if not words:
        sys.exit(f"no bullets found under '## Banned words' in {brand}")
    return words


def compile_words(words):
    parts = []
    for w in words:
        prefix = w.endswith("*")
        core = re.escape(w.rstrip("*")).replace(r"\ ", r"[\s_-]+")
        parts.append(core + (r"\w*" if prefix else ""))
    return re.compile(r"(?<!\w)(" + "|".join(parts) + r")(?!\w)", re.I)


def files(paths):
    for p in paths:
        if os.path.isfile(p):
            yield p
        else:
            for root, dirs, names in os.walk(p):
                dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
                for n in sorted(names):
                    if os.path.splitext(n)[1].lower() in TEXT_EXT:
                        yield os.path.join(root, n)


def scan(path, rx, code_only):
    hits = []
    ext = os.path.splitext(path)[1].lower()
    strings_only = code_only and ext in CODE_EXT
    try:
        lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    except OSError:
        return hits
    for n, line in enumerate(lines, 1):
        chunks = [m.group(2) for m in STRING.finditer(line)] if strings_only else [line]
        for c in chunks:
            for m in rx.finditer(c):
                hits.append(f"{path}:{n}: {m.group(1).upper()} | {c.strip()[:140]}")
    return hits


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--brand", default="content-studio/BRAND.md")
    ap.add_argument("--code", action="store_true", help="scan only string literals in code files")
    ap.add_argument("paths", nargs="+")
    a = ap.parse_args()
    rx = compile_words(load_words(a.brand))
    total = []
    for f in files(a.paths):
        total += scan(f, rx, a.code)
    print("\n".join(total) if total else "banned_words: no hits")
    sys.exit(1 if total else 0)


if __name__ == "__main__":
    main()
