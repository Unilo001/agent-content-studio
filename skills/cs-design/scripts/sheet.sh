#!/bin/bash
# sheet.sh: contact sheets, single frames and 100 % crops for visual review. Needs ffmpeg + ffprobe on PATH
# (or set FFMPEG_DIR). Reads the source, never changes it. Writes only to --out (default $TMPDIR/cs-design-sheets).
#
#   sheet.sh video <video> [--fps 4] [--cols 8] [--width 240] [--from S] [--to S] [--out f.jpg]
#       Contact sheet of a video. Defaults: 4 frames/s, 8 columns, 240 px tiles (phone size in a feed).
#       Over 9 rows the tiles get too small to review: split with --from/--to.
#       Seams and cuts: --from 4.5 --to 5.5 --fps 30 --cols 10 --width 180.
#   sheet.sh slides <dir> [--cols 6] [--width 300] [--out f.jpg]
#       Contact sheet of 01.png, 02.png ... in order (carousel, stills). All must be the same size.
#   sheet.sh frame <video> <time> [--out f.png]
#       One full-resolution frame: measure micro text and edges here, never on a sheet.
#   sheet.sh crop <video|image> <time|-> <x> <y> <w> <h> [--scale 2] [--out f.png]
#       Region at 100 %. <time> in seconds for video, "-" for an image. --scale 2|3|4 enlarges with
#       nearest neighbour: pixels stay visible, nothing smooths away edge faults, banding or halos.
# Always look at the result yourself; never trust someone else's sheet.
set -eu
if [ -n "${FFMPEG_DIR:-}" ]; then FF=$FFMPEG_DIR/ffmpeg; FP=$FFMPEG_DIR/ffprobe; else FF=$(command -v ffmpeg || true); FP=$(command -v ffprobe || true); fi
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (install it or set FFMPEG_DIR)" >&2; exit 2; }
OUT=${TMPDIR:-/tmp}/cs-design-sheets
mkdir -p "$OUT"
usage() { sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
[ $# -ge 2 ] || usage
cmd=$1; shift
fps=4; cols=""; width=""; from=""; to=""; out=""; scale=1; args=()
while [ $# -gt 0 ]; do
  case $1 in
    --fps) fps=$2; shift 2;; --cols) cols=$2; shift 2;; --width) width=$2; shift 2;;
    --from) from=$2; shift 2;; --to) to=$2; shift 2;; --out) out=$2; shift 2;;
    --scale) scale=$2; shift 2;; -h|--help) usage;; *) args+=("$1"); shift;;
  esac
done
n=${#args[@]}
ceil_div() { awk -v a="$1" -v b="$2" 'BEGIN{x=a/b; y=int(x); if (y<x) y++; if (y<1) y=1; print y}'; }
case $cmd in
  video)
    [ "$n" -eq 1 ] || usage
    v=${args[0]}; [ -f "$v" ] || { echo "missing: $v" >&2; exit 2; }
    cols=${cols:-8}; width=${width:-240}; out=${out:-$OUT/$(basename "${v%.*}")-sheet.jpg}
    dur=$("$FP" -v error -show_entries format=duration -of csv=p=0 "$v")
    s=${from:-0}; e=${to:-$dur}
    frames=$(awk -v a="$s" -v b="$e" -v f="$fps" 'BEGIN{x=(b-a)*f; y=int(x); if (y<x) y++; print y}')
    rows=$(ceil_div "$frames" "$cols")
    [ "$rows" -le 40 ] || { echo "$rows rows is too many: lower --fps or split with --from/--to" >&2; exit 2; }
    [ "$rows" -le 9 ] || echo "NOTE: $rows rows; tiles too small to review above 9. Split with --from/--to." >&2
    ss=(); [ -n "$from" ] && ss+=(-ss "$from"); [ -n "$to" ] && ss+=(-to "$to")
    "$FF" -nostdin -v error -y ${ss[@]+"${ss[@]}"} -i "$v" -vf "fps=$fps,scale=$width:-1,tile=${cols}x${rows}" -frames:v 1 -q:v 3 "$out"
    echo "$out  ($frames frames, ${cols}x${rows}, ${s}-${e} s)";;
  slides)
    [ "$n" -eq 1 ] || usage
    d=${args[0]}; [ -d "$d" ] || { echo "not a directory: $d" >&2; exit 2; }
    cols=${cols:-6}; width=${width:-300}; out=${out:-$OUT/$(basename "$(cd "$d" && pwd)")-slides.jpg}
    k=$(ls "$d" | grep -c -E '^[0-9][0-9]\.png$' || true)
    [ "$k" -gt 0 ] || { echo "expected 01.png, 02.png ... in $d" >&2; exit 2; }
    rows=$(ceil_div "$k" "$cols")
    "$FF" -nostdin -v error -y -framerate 1 -start_number 1 -i "$d/%02d.png" -vf "scale=$width:-1,tile=${cols}x${rows}:padding=8:color=0x444444" -frames:v 1 -q:v 3 "$out"
    echo "$out  ($k slides, ${cols}x${rows})";;
  frame)
    [ "$n" -eq 2 ] || usage
    v=${args[0]}; t=${args[1]}; [ -f "$v" ] || { echo "missing: $v" >&2; exit 2; }
    out=${out:-$OUT/$(basename "${v%.*}")-t${t}.png}
    "$FF" -nostdin -v error -y -ss "$t" -i "$v" -frames:v 1 "$out"; echo "$out";;
  crop)
    [ "$n" -eq 6 ] || usage
    src=${args[0]}; t=${args[1]}; x=${args[2]}; y=${args[3]}; w=${args[4]}; h=${args[5]}
    [ -f "$src" ] || { echo "missing: $src" >&2; exit 2; }
    out=${out:-$OUT/$(basename "${src%.*}")-crop-${x}x${y}-${w}x${h}.png}
    vf="crop=$w:$h:$x:$y"; [ "$scale" != 1 ] && vf="$vf,scale=iw*$scale:ih*$scale:flags=neighbor"
    ss=(); [ "$t" != "-" ] && ss+=(-ss "$t")
    "$FF" -nostdin -v error -y ${ss[@]+"${ss[@]}"} -i "$src" -vf "$vf" -frames:v 1 "$out"; echo "$out";;
  *) usage;;
esac
