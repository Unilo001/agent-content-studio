#!/bin/bash
# ref-extract.sh: cut reference stills from a video or image: crop, scale to <= 2048 px, strip metadata, number.
#   ref-extract.sh <source> <out-dir> <spec> [spec ...]
# spec = <sec>:<angle>[:<w>:<h>:<x>:<y>]   angle: front|side|back|three-quarter|top|detail
#   crop is in source pixels; for a photo use sec 0. Look at each result before using it (no people, faces, signs, logos).
set -eu
FF=${FFMPEG:-$(command -v ffmpeg || true)}
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (set FFMPEG)" >&2; exit 2; }
[ $# -ge 3 ] || { sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
src=$1; out=$2; shift 2
[ -f "$src" ] || { echo "no such file: $src" >&2; exit 2; }
mkdir -p "$out"; n=0
for spec in "$@"; do
  IFS=: read -r sec angle w h x y <<<"$spec"
  n=$((n+1)); f=$(printf "%s/%02d-%s.jpg" "$out" "$n" "$angle")
  vf="scale='min(2048,iw)':-2"
  [ -n "${w:-}" ] && vf="crop=$w:$h:$x:$y,$vf"
  "$FF" -v error -nostdin -y -ss "$sec" -i "$src" -frames:v 1 -vf "$vf" -map_metadata -1 -q:v 2 "$f"
  echo "$f"
done
