#!/bin/bash
# order-package.sh: skeleton and check for a 3D/image order package (used when generator access is off).
#   order-package.sh new <package-slug> [asset-slug ...] [--dir <order-folder>]   (or env ORDER_DIR)
#   order-package.sh check <package-folder>
# The order folder is the one BRAND.md names for order packages.
# Slugs: a-z, 0-9, hyphen only. `check` must print PASS before the package is announced.
set -eu
die() { echo "error: $*" >&2; exit 2; }
cmd=${1:-}; shift || true
case $cmd in
new)
  [ $# -ge 1 ] || die "usage: new <package-slug> [asset-slug ...] [--dir D]"
  pkg=$1; shift
  assets=(); dir=${ORDER_DIR:-}
  while [ $# -gt 0 ]; do
    if [ "$1" = "--dir" ]; then dir=${2:-}; shift 2; else assets+=("$1"); shift; fi
  done
  [ -n "$dir" ] || die "no order folder: pass --dir or set ORDER_DIR (see BRAND.md)"
  for s in "$pkg" ${assets[@]+"${assets[@]}"}; do
    [[ $s =~ ^[a-z0-9-]+$ ]] || die "bad slug '$s' (a-z, 0-9, hyphen)"
  done
  out="$dir/$(date +%Y-%m-%d)-$pkg"
  [ ! -e "$out" ] || die "$out exists"
  mkdir -p "$out/references"
  : > "$out/ORDER.md"; : > "$out/image-prompts.txt"; : > "$out/generator-settings.txt"
  echo 'nr,asset_slug,prompt' > "$out/prompts.csv"
  n=0
  for s in ${assets[@]+"${assets[@]}"}; do
    n=$((n+1)); mkdir -p "$out/references/$s"
    cat >> "$out/ORDER.md" <<B
## $n. $s
DELIVER TO: <inbox folder from BRAND.md>/$s/

FILL: what it is, why, where it is used (beat/page), done-criteria (one GLB, one object, no text/logo/person, real size, max triangles), how to do it.

B
    cat >> "$out/image-prompts.txt" <<B
=== $n. $s ===
FILL: <object: shape, proportions, materials, colours>, a single object, centred with generous margin,
full object visible, 3/4 front view from slightly above, plain light-grey seamless studio background,
soft even studio lighting, soft contact shadow, matte materials, clean product render, FILL style
Avoid: text, letters, numbers, logo, brand marks, watermark, people, hands, faces, multiple objects,
cropped object, busy background, dramatic shadows
Format: 1:1

B
    cat >> "$out/generator-settings.txt" <<B
=== $n. $s ===
MODE: FILL (image-to-3D | multi-view | text-to-3D)
MODEL: FILL (detailed | low-poly clean topology)
TEXTURE: FILL (off | on, standard | on, detailed)
MAX TRIANGLES: FILL (20000 hero | 8000 background | 15000 web)
TEXTURE SIZE: FILL (2048 | 1024)
EXPORT: GLB, single file, name $s.glb
DELIVER TO: <inbox>/$s/

B
    echo "$n,$s,\"FILL\"" >> "$out/prompts.csv"
  done
  echo "created $out"; echo "fill every FILL, then: $0 check \"$out\""
  ;;
check)
  d=${1:-}; [ -d "$d" ] || die "usage: check <package-folder>"
  bad=0
  for f in ORDER.md image-prompts.txt prompts.csv generator-settings.txt; do
    [ -f "$d/$f" ] || { echo "FAIL missing $f"; bad=1; continue; }
    if grep -q 'FILL' "$d/$f"; then echo "FAIL $f still has FILL placeholders"; bad=1; fi
  done
  [ $bad -eq 0 ] || exit 1
  blocks=$(grep -c '^=== [0-9]*\. ' "$d/image-prompts.txt" || true)
  rows=$(($(wc -l < "$d/prompts.csv") - 1))
  orders=$(grep -c '^## [0-9]*\. ' "$d/ORDER.md" || true)
  sets=$(grep -c '^=== [0-9]*\. ' "$d/generator-settings.txt" || true)
  deliver=$(grep -c '^DELIVER TO:' "$d/ORDER.md" || true)
  for pair in "image-prompts:$blocks" "prompts.csv:$rows" "ORDER.md:$orders" "generator-settings:$sets" "DELIVER TO lines:$deliver"; do
    [ "${pair#*:}" -eq "$blocks" ] || { echo "FAIL count mismatch: ${pair%%:*} has ${pair#*:}, image-prompts has $blocks"; bad=1; }
  done
  [ "$blocks" -gt 0 ] || { echo "FAIL no assets"; bad=1; }
  [ $bad -eq 0 ] && echo "PASS ($blocks assets)" || exit 1
  ;;
*) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
