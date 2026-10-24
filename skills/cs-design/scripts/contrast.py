#!/usr/bin/env python3
"""contrast.py: WCAG 2.2 contrast checker. Measures, reports, changes nothing. Python 3 stdlib (+ optional Pillow).

  python3 contrast.py "#DCE3EA" "#171D24"                 # two colors, order does not matter
  python3 contrast.py "#E27A78" "#171D24" --min 4.5       # exit 1 if below threshold
  python3 contrast.py --image slide.png --fg 540,300 --bg 40,40 [--r 2]   # RENDERED pair (needs Pillow)

--image takes the median of (2r+1)^2 pixels around each point. Use it on finished slides, stills and
video frames: the hex in source is not what ends up in the file (compression, grain, blending, scrims).
Pick a pixel in the middle of a thick glyph stroke, not on the anti-aliased edge, and sample the
worst background under the text (lightest photo area under a scrim).

Thresholds (WCAG 2.2): body text 4.5; large text 3 (>= 24 px, or >= 18.7 px bold); non-text (control
edge, focus ring, chart mark, icon) 3. AAA: 7 / 4.5. Exit 0 ok, 1 below --min, 2 usage error.
"""
import argparse
import re
import statistics
import sys


def lin(c):
    c /= 255.0
    return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4


def lum(rgb):
    r, g, b = (lin(x) for x in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def ratio(a, b):
    la, lb = lum(a), lum(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)


def hexrgb(h):
    h = h.strip().lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    if not re.fullmatch(r"[0-9a-fA-F]{6}", h):
        raise ValueError("bad hex: " + h)
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def sample(img, xy, r):
    x, y = (int(v) for v in xy.split(","))
    px = [img.getpixel((i, j))[:3] for i in range(max(0, x - r), min(img.width, x + r + 1))
          for j in range(max(0, y - r), min(img.height, y + r + 1))]
    return tuple(int(statistics.median(p[k] for p in px)) for k in range(3))


def report(fg, bg, mn):
    cr = ratio(fg, bg)
    print("fg #%02X%02X%02X on bg #%02X%02X%02X: %.2f:1" % (fg + bg + (cr,)))
    print("  body 4.5: %s | large/non-text 3: %s | AAA body 7: %s" % (
        *("pass" if cr >= t else "FAIL" for t in (4.5, 3, 7)),))
    return 1 if mn and cr < mn else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("colors", nargs="*")
    ap.add_argument("--min", type=float)
    ap.add_argument("--image")
    ap.add_argument("--fg")
    ap.add_argument("--bg")
    ap.add_argument("--r", type=int, default=2)
    a = ap.parse_args()
    try:
        if a.image:
            from PIL import Image
            img = Image.open(a.image).convert("RGB")
            return report(sample(img, a.fg, a.r), sample(img, a.bg, a.r), a.min)
        if len(a.colors) != 2:
            ap.print_usage()
            return 2
        return report(hexrgb(a.colors[0]), hexrgb(a.colors[1]), a.min)
    except (ValueError, ImportError, AttributeError) as e:
        print("error: %s" % e)
        return 2


if __name__ == "__main__":
    sys.exit(main())
