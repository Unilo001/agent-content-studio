#!/usr/bin/env python3
"""readtime.py: minimum hold time for on-screen text cards. Python 3 stdlib only.

One card:
  python3 readtime.py "Which pan heats faster?"
  python3 readtime.py --kind label --link "PAN 24 cm"
  python3 readtime.py --kind hook "Burnt in 30 seconds."
  python3 readtime.py --vo "about 94 C"            # card shown under voice-over

Whole timeline (one card per line: start-end | kind | text; # = comment):
  python3 readtime.py --plan cards.txt [--vo] [--inout 0.3]
    0.3-3.0 | hook  | Burnt in 30 seconds.
    0.0-17.0 | mark | Illustration, example values
    3.4-6.0 | explain | Steel pan: 2 min to boil

Kinds: explain (default), label, hook, tag, product, payoff, cta, mark.
Formulas are house heuristics, not measured comprehension. Tune the constants to the brand.
  explain/payoff  max(1.8, 0.75 + 0.40*W + 0.50*N)
  label/tag       max(1.2, 0.35*W + 0.5) + 0.5*N   (+1.0 with --link: must be tied to something in the frame)
  hook            max(chars/20, 2.0), ideally ~3 s
  product         as explain, at least 2.0 s;  cta  as explain, at least 3.2 s
  always plan     max(formula, W/3 + 0.6)
W = space-separated tokens containing a letter or digit. N = numeric values.
Hold = from fully readable to exit start; --plan subtracts --inout (default 0.3 s) from the interval.
Exit 1 if any VIOLATION; WARN means judge it yourself.
"""
import argparse
import re
import sys

NUM = re.compile(r"\d+(?:[.,]\d+)?")
KINDS = ("explain", "label", "hook", "tag", "product", "payoff", "cta", "mark")


def tokens(text):
    return [t for t in text.split() if re.search(r"[^\W_]", t)]


def floor_for(text, kind, link=False):
    w, n, chars = len(tokens(text)), len(NUM.findall(text)), len(text.strip())
    if kind == "mark":
        return w, n, 0.0
    if kind in ("label", "tag"):
        f = max(1.2, 0.35 * w + 0.5) + 0.5 * n + (1.0 if link else 0.0)
    elif kind == "hook":
        f = max(chars / 20.0, 2.0)
    else:
        f = max(1.8, 0.75 + 0.40 * w + 0.50 * n)
        if kind == "product":
            f = max(f, 2.0)
        if kind == "cta":
            f = max(f, 3.2)
    return w, n, max(f, w / 3.0 + 0.6)


def notes(text, kind, w, n, vo):
    bad, warn = [], []
    if kind in ("explain", "payoff", "product", "cta") and w > 8:
        bad.append("TOO MUCH: %d tokens (max 8, aim 3-6). Split or cut; more hold time does not fix clutter." % w)
    if kind == "hook":
        if w > 12:
            bad.append("hook: %d words in frame 0 (max 12 in total)" % w)
        elif w > 6:
            warn.append("hook: %d words; headline should be at most 6 main words" % w)
    if kind == "explain" and re.search(r"[.!?]\s+\S", text):
        warn.append("several sentences on one card: one idea, one focus number")
    if kind not in ("mark", "cta") and n > 2:
        warn.append("%d numbers on one card: one focus number (two if contrasted)" % n)
    if vo and kind not in ("mark", "cta", "tag") and not (w <= 3 or (n == 1 and w <= 4)):
        bad.append("VO rule: under voice-over max 3 words or one number per card (W=%d, N=%d)" % (w, n))
    return bad, warn


def single(a):
    w, n, f = floor_for(a.text, a.kind, a.link)
    bad, warn = notes(a.text, a.kind, w, n, a.vo)
    print("[%s] W=%d N=%d  plan hold >= %.2f s  (cap ~%.1f s unless something new moves)" % (a.kind, w, n, f, 2 * f))
    print("     " + a.text)
    for m in bad:
        print("     VIOLATION " + m)
    for m in warn:
        print("     WARN " + m)
    return 1 if bad else 0


def plan(a):
    cards = []
    for i, raw in enumerate(open(a.plan, encoding="utf-8"), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        p = [x.strip() for x in line.split("|", 2)]
        if len(p) < 3 or "-" not in p[0] or p[1] not in KINDS:
            print("line %d: cannot parse %r (format: start-end | kind | text)" % (i, line))
            return 2
        s, e = p[0].split("-", 1)
        cards.append((float(s), float(e), p[1], p[2]))
    cards.sort(key=lambda c: (c[0], c[1]))
    rc, prev = 0, None
    print("start-end    hold/plan   kind      text")
    for s, e, kind, text in cards:
        w, n, f = floor_for(text, kind)
        bad, warn = notes(text, kind, w, n, a.vo)
        hold = max(0.0, e - s - a.inout)
        if kind != "mark":
            if hold + 1e-9 < f:
                bad.append("hold %.2f s < plan %.2f s" % (hold, f))
            elif hold > 2 * f + 1.0:
                warn.append("hold %.2f s is long (> 2x floor); add motion or cut" % hold)
            if prev is not None and s - prev < 1.4 and kind != "label":
                warn.append("new card %.2f s after previous started (min 1.4 s)" % (s - prev))
            prev = s
        print("%4.1f-%-5.1f   %4.2f/%4.2f   %-9s %s" % (s, e, hold, f, kind, text))
        for m in bad:
            print("     VIOLATION " + m)
            rc = 1
        for m in warn:
            print("     WARN " + m)
    starts = [c[0] for c in cards if c[2] != "mark"]
    for s in starts:
        if sum(1 for t in starts if s <= t < s + 15) > 6:
            print("WARN more than 6 cards in a 15 s window starting at %.1f s" % s)
            break
    return rc


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("text", nargs="?")
    ap.add_argument("--kind", default="explain", choices=KINDS)
    ap.add_argument("--link", action="store_true")
    ap.add_argument("--vo", action="store_true")
    ap.add_argument("--plan")
    ap.add_argument("--inout", type=float, default=0.3)
    a = ap.parse_args()
    if a.plan:
        return plan(a)
    if not a.text:
        ap.print_usage()
        return 2
    return single(a)


if __name__ == "__main__":
    sys.exit(main())
