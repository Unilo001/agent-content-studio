#!/bin/bash
# loudness-check.sh: self-check of a FINISHED mix before handover. Measures, never modifies. Needs ffmpeg + ffprobe.
#
#   loudness-check.sh <final.mp4|m4a|wav> [--hits 7.55,7.72] [--vo vo.wav --sfx sfx.wav]
#
# Checks (defaults; override with env TARGET_LUFS TOL_LU TP_WARN TP_FAIL):
#   1 integrated loudness TARGET_LUFS (-15) +- TOL_LU (1)            FAIL outside
#   2 true peak <= TP_WARN (-1.5) PASS, up to TP_FAIL (-1.0) WARN, above FAIL   (valid only on the final AAC)
#   3 sound present at 0.0 s: mean level of the first 0.3 s above -50 dB          FAIL if not
#   4 digital silence: any stretch >= 0.3 s below -60 dB                          FAIL
#   5 150 Hz high-pass proxy ("phone speaker"): loudness loss > 3 LU              WARN
#   6 --hits: peak of 20 ms at each hit minus mean of the 300 ms before; needs >= +6 dB   FAIL
#   7 --vo/--sfx: VO mean over SFX mean per 0.5 s window where VO is active; < +5 dB FAIL, 5-6 WARN
# Exit 0 = no FAIL, 1 = at least one FAIL, 2 = usage/tool error. LRA is printed as information.
set -u
FF=${FFMPEG:-$(command -v ffmpeg || true)}
[ -n "$FF" ] && [ -x "$FF" ] || { echo "ffmpeg not found (set FFMPEG)" >&2; exit 2; }
f=${1:-}; [ -f "$f" ] || { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
shift
hits=""; vo=""; sfx=""
while [ $# -gt 0 ]; do case $1 in --hits) hits=$2; shift 2;; --vo) vo=$2; shift 2;; --sfx) sfx=$2; shift 2;; *) echo "unknown arg $1" >&2; exit 2;; esac; done
TARGET=${TARGET_LUFS:--15}; TOL=${TOL_LU:-1}; TPW=${TP_WARN:--1.5}; TPF=${TP_FAIL:--1.0}
fails=0
say() { printf '%-5s %s\n' "$1" "$2"; [ "$1" = FAIL ] && fails=$((fails+1)); return 0; }
lt() { awk -v a="$1" -v b="$2" 'BEGIN{exit !(a<b)}'; }   # a < b

ebu() { "$FF" -nostdin -hide_banner -i "$1" -vn -af "${2:+$2,}ebur128=peak=true" -f null - 2>&1 | awk '/Summary:/{s=1} s'; }
sum=$(ebu "$f")
I=$(echo "$sum" | awk '/^ *I:/{print $2}'); LRA=$(echo "$sum" | awk '/^ *LRA:/{print $2; exit}'); TP=$(echo "$sum" | awk '/Peak:/{print $2}' | tail -1)
[ -n "$I" ] && [ -n "$TP" ] || { echo "could not read loudness summary" >&2; exit 2; }
if awk -v i="$I" -v t="$TARGET" -v o="$TOL" 'BEGIN{d=i-t; if(d<0)d=-d; exit !(d<=o)}'; then say PASS "integrated $I LUFS (target $TARGET +-$TOL), LRA $LRA LU (info)"; else say FAIL "integrated $I LUFS outside $TARGET +-$TOL"; fi
if lt "$TPF" "$TP"; then say FAIL "true peak $TP dBTP above $TPF"; elif lt "$TPW" "$TP"; then say WARN "true peak $TP dBTP between $TPW and $TPF"; else say PASS "true peak $TP dBTP <= $TPW (valid only on the final AAC)"; fi

mean_db() { # file start dur -> mean_volume in dB
  "$FF" -nostdin -hide_banner -ss "$2" -t "$3" -i "$1" -vn -af volumedetect -f null - 2>&1 | awk '/mean_volume:/{print $5}'
}
max_db() { "$FF" -nostdin -hide_banner -ss "$2" -t "$3" -i "$1" -vn -af volumedetect -f null - 2>&1 | awk '/max_volume:/{print $5}'; }
m0=$(mean_db "$f" 0 0.3)
if [ -z "$m0" ] || lt "$m0" -50; then say FAIL "no sound at 0.0 s (first 0.3 s mean ${m0:-n/a} dB)"; else say PASS "sound at 0.0 s (first 0.3 s mean $m0 dB)"; fi

sil=$("$FF" -nostdin -hide_banner -i "$f" -vn -af silencedetect=n=-60dB:d=0.3 -f null - 2>&1 | grep -c 'silence_start')
if [ "${sil:-0}" -gt 0 ]; then say FAIL "$sil stretch(es) of digital silence >= 0.3 s (pad the sidechain key?)"; else say PASS "no digital silence >= 0.3 s"; fi

Ihp=$(ebu "$f" "highpass=f=150" | awk '/^ *I:/{print $2}')
if [ -n "$Ihp" ]; then
  loss=$(awk -v a="$I" -v b="$Ihp" 'BEGIN{printf "%.1f", a-b}')
  if lt 3 "$loss"; then say WARN "150 Hz high-pass loses $loss LU (hits may be bass-only on phone speakers)"; else say PASS "150 Hz high-pass loses $loss LU"; fi
fi

if [ -n "$hits" ]; then
  IFS=, read -ra H <<<"$hits"
  for t in "${H[@]}"; do
    b=$(awk -v t="$t" 'BEGIN{x=t-0.3; if(x<0)x=0; printf "%.3f", x}')
    bed=$(mean_db "$f" "$b" 0.3); pk=$(max_db "$f" "$t" 0.02)
    if [ -z "$bed" ] || [ -z "$pk" ]; then say WARN "hit $t s: could not measure"; continue; fi
    d=$(awk -v p="$pk" -v b="$bed" 'BEGIN{printf "%.1f", p-b}')
    if lt "$d" 6; then say FAIL "hit $t s: peak ${pk} dB is only +$d dB over the bed (${bed} dB), need >= +6"; else say PASS "hit $t s: +$d dB over the bed"; fi
  done
fi

if [ -n "$vo" ] && [ -n "$sfx" ]; then
  dur=$("${FFPROBE:-${FF%ffmpeg}ffprobe}" -v error -show_entries format=duration -of csv=p=0 "$vo" 2>/dev/null)
  worst=999; n=0
  for t in $(awk -v d="${dur:-0}" 'BEGIN{for(t=0;t<d-0.5;t+=0.5) printf "%.1f ", t}'); do
    v=$(mean_db "$vo" "$t" 0.5); s=$(mean_db "$sfx" "$t" 0.5)
    [ -n "$v" ] && [ -n "$s" ] || continue
    lt "$v" -45 && continue                      # VO not active in this window
    n=$((n+1)); d=$(awk -v v="$v" -v s="$s" 'BEGIN{printf "%.1f", v-s}')
    lt "$d" "$worst" && worst=$d
  done
  if [ "$n" -eq 0 ]; then say WARN "VO margin: no active VO windows found"
  elif lt "$worst" 5; then say FAIL "VO margin min $worst dB (< +5) over $n windows"
  elif lt "$worst" 6; then say WARN "VO margin min $worst dB over $n windows"
  else say PASS "VO margin min $worst dB over $n windows"; fi
fi
echo "Measured, not heard by a human."
[ $fails -eq 0 ] && exit 0 || exit 1
