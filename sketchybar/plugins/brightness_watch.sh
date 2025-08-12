#!/usr/bin/env bash

M1DDC="/opt/homebrew/bin/m1ddc"

detect_pct() {
  for d in 1 2 3 4 5 6; do
    pct="$("$M1DDC" display "$d" get luminance 2>/dev/null)" || continue
    [[ "$pct" =~ ^[0-9]+ ]] && { echo "${pct%%.*}"; return 0; }
  done
  return 1
}

if pct="$(detect_pct)"; then
  # show icon + init values so they aren't 0 after reload
  sketchybar --set brightness_icon drawing=on label="${pct}%"
  sketchybar --set brightness slider.percentage="$pct" slider.width=0
else
  sketchybar --set brightness_icon drawing=off \
             --set brightness slider.width=0
fi
