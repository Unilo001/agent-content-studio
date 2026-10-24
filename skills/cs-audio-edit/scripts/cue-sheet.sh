#!/bin/bash
# cue-sheet.sh: one image per cue: the 30 fps frames around a hit (top) over the waveform of the same window (bottom).
# Read it: the visible contact frame should have a transient under it. A hit with no transient under the contact
# frame = wrong cue time, or the sound was placed on the clip start.
#
#   cue-sheet.sh <video.mp4> <cue_seconds> [half_window_s=0.2]
# Output: ${OUT:-${TMPDIR:-/tmp}/cs-audio-edit}/cue_<seconds>.png      Needs ffmpeg.
set -eu
FF=${FFMPEG:-$(command -v ffmpeg || true)}
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (set FFMPEG)" >&2; exit 2; }
[ $# -ge 2 ] || { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
src=$1; cue=$2; hw=${3:-0.2}
[ -f "$src" ] || { echo "no such file: $src" >&2; exit 2; }
OUT=${OUT:-${TMPDIR:-/tmp}/cs-audio-edit}; mkdir -p "$OUT"
start=$(awk -v c="$cue" -v h="$hw" 'BEGIN{s=c-h; if(s<0)s=0; printf "%.3f", s}')
len=$(awk -v h="$hw" 'BEGIN{printf "%.3f", 2*h}')
n=$(awk -v l="$len" 'BEGIN{printf "%d", l*30+0.5}'); [ "$n" -ge 1 ] || n=1
w=$((n*108)); tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
"$FF" -v error -nostdin -y -ss "$start" -t "$len" -i "$src" -vf "fps=30,scale=108:-2,tile=${n}x1:padding=0" -frames:v 1 "$tmp/frames.png"
"$FF" -v error -nostdin -y -ss "$start" -t "$len" -i "$src" -filter_complex "[0:a]aformat=channel_layouts=mono,showwavespic=s=${w}x120:colors=white[w]" -map "[w]" -frames:v 1 "$tmp/wave.png"
out="$OUT/cue_${cue}.png"
"$FF" -v error -nostdin -y -i "$tmp/frames.png" -i "$tmp/wave.png" -filter_complex "[1:v]scale=${w}:120[w2];[0:v][w2]vstack" -frames:v 1 "$out"
echo "cue sheet: $out  (window $start s + $len s, $n frames; cue at frame index $(awk -v c="$cue" -v s="$start" 'BEGIN{printf "%d", (c-s)*30+0.5}'))"
