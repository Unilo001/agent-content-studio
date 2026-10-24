#!/bin/bash
# grade-measure.sh: measure a grade instead of eyeballing it. Prints per-clip signalstats means before and after,
# and writes a before/after sheet. Read-only. Needs ffmpeg.
#
#   grade-measure.sh <before> <after> [t1,t2,t3]     default times 0.4,1.5,2.6
# Columns: YAVG (mean luma), SATAVG (mean saturation), YLOW/YHIGH (2nd/98th percentile luma), YMIN/YMAX.
# Guideline: YMAX < 250 (skin, reds, sky not clipped); blacks near your base tone, not crushed to 0 unless the content is black.
# HDR/HLG sources: tone-map "before" first, or the comparison is meaningless.
# Output sheet: ${OUT:-${TMPDIR:-/tmp}/cs-audio-edit}/grade_sheet.png (top row before, bottom row after).
set -eu
FF=${FFMPEG:-$(command -v ffmpeg || true)}
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (set FFMPEG)" >&2; exit 2; }
[ $# -ge 2 ] || { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
a=$1; b=$2; times=${3:-0.4,1.5,2.6}
OUT=${OUT:-${TMPDIR:-/tmp}/cs-audio-edit}; mkdir -p "$OUT"
stats() { "$FF" -nostdin -v error -i "$1" -vf "signalstats,metadata=print:file=-" -f null - 2>/dev/null | awk -F= '
  /YAVG=/{y+=$2;n++} /SATAVG=/{s+=$2} /YLOW=/{l+=$2} /YHIGH=/{h+=$2}
  /YMIN=/{if(!mi||$2<mi)mi=$2} /YMAX=/{if($2>ma)ma=$2}
  END{if(n) printf "%6.1f %6.1f %6.1f %6.1f %5d %5d", y/n, s/n, l/n, h/n, mi, ma}'; }
printf '%-8s %6s %6s %6s %6s %5s %5s\n' "" YAVG SATAVG YLOW YHIGH YMIN YMAX
printf '%-8s %s\n' before "$(stats "$a")"
printf '%-8s %s\n' after "$(stats "$b")"
IFS=, read -ra T <<<"$times"; i=0; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
for t in "${T[@]}"; do i=$((i+1))
  "$FF" -v error -nostdin -y -ss "$t" -i "$a" -frames:v 1 -vf scale=360:-2 "$tmp/a$i.png"
  "$FF" -v error -nostdin -y -ss "$t" -i "$b" -frames:v 1 -vf scale=360:-2 "$tmp/b$i.png"
done
"$FF" -v error -nostdin -y -i "$tmp/a%d.png" -i "$tmp/b%d.png" -filter_complex "[0:v]tile=${i}x1[t];[1:v]tile=${i}x1[u];[t][u]vstack" -frames:v 1 "$OUT/grade_sheet.png"
echo "sheet: $OUT/grade_sheet.png (top before, bottom after). Flags are questions, not verdicts: look at the sheet."
