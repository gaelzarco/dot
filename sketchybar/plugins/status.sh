#!/usr/bin/env bash

URL="${WEBSITE_URL:-https://server.xarco.net}"
LABEL="xarco.net"
TIMEOUT="${TIMEOUT:-2}"

GRAY=0xffc0c0c0
GREEN=0xff86e7be
YELLOW=0xffffef96
RED=0xffff9898

read -r CODE T < <(curl -sS -o /dev/null -w "%{http_code} %{time_total}\n" --head --max-time "$TIMEOUT" "$URL" 2>/dev/null)
OK=$?

ms() { awk -v t="${1:-0}" 'BEGIN{printf "%d", (t*1000)+0.5}'; }

SPIN_NAME="site_status_spinner_${NAME}"

if (( OK != 0 )) || [[ -z "$CODE" ]] || [[ "$CODE" == "000" ]]; then
  pkill -f "$SPIN_NAME" 2>/dev/null
  sketchybar --set "$NAME" icon="●" icon.color=${RED} icon.width=16 icon.align=center label.padding_left=4 label="DOWN" label.color=${RED}
  exit 0
fi

LAT=$(ms "$T")

if [[ "$CODE" =~ ^1..$ || "$CODE" =~ ^2..$ || "$CODE" =~ ^3..$ ]]; then
  sketchybar --set "$NAME" label="${LABEL} ${LAT}ms" icon.width=16 icon.align=center
  pkill -f "$SPIN_NAME" 2>/dev/null
  ( exec -a "$SPIN_NAME" bash -lc '
      export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
      frames=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")
      while true; do
        for f in "${frames[@]}"; do
          sketchybar --set '"$NAME"' icon="$f" icon.color='"$GRAY"' icon.width=16 icon.align=center label.padding_left=6
          sleep 0.1
        done
      done
    ' ) &
  else
    pkill -f "$SPIN_NAME" 2>/dev/null
    sketchybar --set "$NAME" icon="●" label="${LABEL} ${LAT}ms" icon.color=${GREEN}
  fi
elif [[ "$CODE" =~ ^4..$ ]]; then
  pkill -f "$SPIN_NAME" 2>/dev/null
  sketchybar --set "$NAME" icon="●" label="${LABEL} ${LAT}ms" icon.color=${YELLOW}
else
  pkill -f "$SPIN_NAME" 2>/dev/null
  sketchybar --set "$NAME" icon="●" label="${LABEL} ${CODE}" icon.color=${RED}
fi
