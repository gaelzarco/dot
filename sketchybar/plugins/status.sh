#!/usr/bin/env bash

URL="${WEBSITE_URL:-https://server.xarco.net}"
LABEL="${LABEL:-xarco.net}"
TIMEOUT_MS="${TIMEOUT_MS:-1000}"

GREEN=0xff00e676
YELLOW=0xffffc400
RED=0xffff1744

HOST="${URL#*://}"; HOST="${HOST%%/*}"

SPIN_NAME="site_status_spinner_${NAME}"

OUT="$(ping -n -c 1 -W "$TIMEOUT_MS" "$HOST" 2>&1)"
OK=$?

if (( OK != 0 )) || ! grep -q "time=" <<<"$OUT"; then
  pkill -f "$SPIN_NAME" 2>/dev/null
  sketchybar --set "$NAME" icon="●" icon.color=${RED} icon.width=16 icon.align=center \
                   icon.padding_right=5 label="${LABEL} DOWN"
  exit 0
fi

LAT_RAW="$(sed -n 's/.*time=\([0-9.]*\) ms.*/\1/p' <<<"$OUT")"
LAT_MS="$(awk -v t="$LAT_RAW" 'BEGIN{printf "%d", t+0.5}')"
LAT="$LAT_MS"

COLOR=$GREEN
(( LAT_MS > 50 )) && COLOR=$YELLOW
(( LAT_MS > 100 )) && COLOR=$RED

# --- OPTIONAL SPINNER -------------------------------
#   sketchybar --set "$NAME" label="${LABEL} ${LAT}ms" icon.width=16 icon.align=center
#   pkill -f "$SPIN_NAME" 2>/dev/null
#   ( exec -a "$SPIN_NAME" bash -lc '
#       export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
#       frames=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")
#       while true; do
#         for f in "${frames[@]}"; do
#           sketchybar --set '"$NAME"' icon="$f" icon.color='"$GRAY"' icon.width=16 icon.align=center label.padding_left=6
#           sleep 0.1
#         done
#       done
#     ' ) &

pkill -f "$SPIN_NAME" 2>/dev/null
sketchybar --set "$NAME" icon="●" icon.color=${COLOR} icon.width=16 icon.align=center \
                 icon.padding_right=5 label.color=0xffffffff label="${LABEL} ${LAT_MS}ms"
