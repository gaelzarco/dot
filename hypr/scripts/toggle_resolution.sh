#!/usr/bin/env bash
set -euo pipefail

MONITOR="DP-4"

# Grab JSON safely
JSON="$(hyprctl -j monitors 2>/dev/null || true)"
if [[ -z "${JSON}" ]]; then
  echo "hyprctl returned no JSON. Are you inside Hyprland?"
  exit 1
fi

# needs: jq
read -r W H RR <<<"$(printf '%s' "$JSON" |
  jq -er --arg m "$MONITOR" '.[] | select(.name==$m) | "\(.width) \(.height) \(.refreshRate)"')"

# Fallback if monitor not found
if [[ -z "${W:-}" || -z "${H:-}" || -z "${RR:-}" ]]; then
  echo "Monitor '$MONITOR' not found in hyprctl output."
  exit 1
fi

if [[ "$W" -eq 3840 && "$H" -eq 2160 ]]; then
  echo "→ 1920x1080@60"
  hyprctl keyword monitor "$MONITOR,1920x1080@60.00,0x0,1"
elif [[ "$W" -eq 1920 && "$H" -eq 1080 ]]; then
  echo "→ 3840x2160@144"
  hyprctl keyword monitor "$MONITOR,3840x2160@144.00,0x0,1.5"
else
  echo "Unknown mode (${W}x${H}@${RR}). Defaulting to 3840x2160@144."
  hyprctl keyword monitor "$MONITOR,3840x2160@144.00,0x0,1.5"
fi
