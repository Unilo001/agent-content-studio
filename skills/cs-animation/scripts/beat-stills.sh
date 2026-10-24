#!/bin/bash
# beat-stills.sh: stills for per-beat self-critique, 30 fps stripes and YDIF from a finished render. Read-only.
# Needs ffmpeg + ffprobe (set FFMPEG / FFPROBE or have them in PATH).
#
#   beat-stills.sh beats  <mp4> [t1 t2 ...]   One full-size PNG per time + a contact sheet (6 columns).
#                                             No times: t=0, every 1.5 s, and the last frame.
#   beat-stills.sh stripe <mp4> <from> <to>   Every frame (30 fps) in one sheet, for seams/impacts. Keep it <= 2 s.
#   beat-stills.sh ydif   <mp4> [from] [to]   YDIF per frame + mean. "ydif x.mp4 0 1" = hook motion (aim > 5).
#                                             Around a hit, the peak is the actual cue time.
#
# Output dir: $OUT (default ${TMPDIR:-/tmp}/cs-animation/<file name>/).
set -eu
FF=${FFMPEG:-$(command -v ffmpeg || true)}
FP=${FFPROBE:-$(command -v ffprobe || true)}
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (set FFMPEG)" >&2; exit 2; }
[ -n "$FP" ] && [ -x "$FP" ] || { echo "ffprobe not found (set FFPROBE)" >&2; exit 2; }
usage() { sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
[ $# -ge 2 ] || usage
cmd=$1; src=$2; shift 2
[ -f "$src" ] || { echo "no such file: $src" >&2; exit 2; }
name=$(basename "$src"); name=${name%.*}
OUT=${OUT:-${TMPDIR:-/tmp}/cs-animation/$name}
mkdir -p "$OUT"
dur=$("$FP" -v error -show_entries format=duration -of csv=p=0 "$src")

case $cmd in
beats)
  times=("$@")
  if [ ${#times[@]} -eq 0 ]; then
    times=($(awk -v d="$dur" 'BEGIN{for(t=0;t<d-0.05;t+=1.5) printf "%.2f ", t}'))
  fi
  rm -f "$OUT"/beat_*.png
  i=0
  for t in "${times[@]}"; do
    i=$((i+1)); f=$(printf "%s/beat_%03d_%06.2f.png" "$OUT" "$i" "$t")
    "$FF" -v error -nostdin -y -ss "$t" -i "$src" -frames:v 1 "$f"
    echo "$(basename "$f")  t=$t"
  done
  i=$((i+1)); last=$(printf "%s/beat_%03d_last.png" "$OUT" "$i")
  "$FF" -v error -nostdin -y -sseof -0.07 -i "$src" -update 1 -frames:v 1 "$last"
  echo "$(basename "$last")  t=last (duration $dur s)"
  rows=$(( (i + 5) / 6 ))
  "$FF" -v error -nostdin -y -pattern_type glob -i "$OUT/beat_*.png" \
    -vf "scale=270:-1,tile=6x${rows}:padding=6:color=white" -frames:v 1 "$OUT/sheet.png"
  echo "sheet: $OUT/sheet.png ($i images, in time order)"
  ;;
stripe)
  [ $# -eq 2 ] || usage
  fra=$1; til=$2
  len=$(awk -v a="$fra" -v b="$til" 'BEGIN{printf "%.3f", b-a}')
  n=$(awk -v l="$len" 'BEGIN{printf "%d", l*30+0.5}'); rows=$(( (n + 9) / 10 ))
  out="$OUT/stripe_${fra}-${til}.png"
  "$FF" -v error -nostdin -y -ss "$fra" -t "$len" -i "$src" \
    -vf "fps=30,scale=216:-1,tile=10x${rows}:padding=2:color=white" -frames:v 1 "$out"
  echo "stripe: $out ($n frames, 10 per row, start $fra s)"
  ;;
ydif)
  fra=${1:-0}; til=${2:-$dur}
  len=$(awk -v a="$fra" -v b="$til" 'BEGIN{printf "%.3f", b-a}')
  "$FF" -nostdin -v error -ss "$fra" -t "$len" -i "$src" \
    -vf "signalstats,metadata=print:key=lavfi.signalstats.YDIF:file=-" -f null - 2>/dev/null |
  awk -v off="$fra" '
    /pts_time/ { for (i=1;i<=NF;i++) if ($i ~ /^pts_time:/) { split($i,a,":"); t=a[2]+off } }
    /YDIF=/    { split($0,b,"="); v=b[2]+0; printf "%7.3f s  YDIF %6.2f\n", t, v; s+=v; n++; if (v>m) {m=v; mt=t} }
    END        { if (n) printf "mean %.2f over %d frames, peak %.2f at %.3f s\n", s/n, n, m, mt }'
  ;;
*) usage ;;
esac
