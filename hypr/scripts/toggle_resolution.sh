#!/usr/bin/env bash
set -euo pipefail

MONITOR="$(hyprctl -j activeworkspace | jq -r '.monitor')"
JSON="$(hyprctl -j monitors)"

CURMODE="$(jq -r --arg m "$MONITOR" '.[] | select(.name==$m) | .currentMode' <<<"$JSON")"
[[ -n "$CURMODE" && "$CURMODE" != "null" ]] || { echo "No currentMode for $MONITOR"; exit 1; }

if [[ "$CURMODE" == 3840x2160@* ]]; then
  echo "→ 1920x1080@60"
  hyprctl keyword monitor "$MONITOR,1920x1080@60,0x0,1"
else
  echo "→ 3840x2160@143.98"
  hyprctl keyword monitor "$MONITOR,3840x2160@143.98,0x0,1.6"
fi
