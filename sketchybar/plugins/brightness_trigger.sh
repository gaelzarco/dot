#!/usr/bin/env bash

M1DDC="/opt/homebrew/bin/m1ddc"
DDC_DISPLAY="${DDC_DISPLAY:-}"

detect_display() {
  for d in 1 2 3 4 5 6; do
    out="$("$M1DDC" display "$d" get luminance 2>/dev/null)" || continue
    [[ "$out" =~ ^[0-9]+$ ]] && { echo "$d"; return; }
  done
}

read_percent() { "$M1DDC" display "$1" get luminance 2>/dev/null; }

main() {
  [[ -x "$M1DDC" ]] || exit 0
  [[ -z "$DDC_DISPLAY" ]] && DDC_DISPLAY="$(detect_display)"
  [[ -z "$DDC_DISPLAY" ]] && exit 0

  pct="$(read_percent "$DDC_DISPLAY")"; pct="${pct%%.*}"
  if [[ "$pct" == "0" ]]; then
    sleep 0.1
    pct="$(read_percent "$DDC_DISPLAY")"; pct="${pct%%.*}"
  fi

  if [[ "$pct" =~ ^[0-9]+$ && $pct -ge 0 && $pct -le 100 ]]; then
    sketchybar --set brightness slider.percentage="$pct" slider.width=0
    sketchybar --set brightness_icon label="${pct}%"
    sketchybar --trigger brightness_change SRC=ddc INFO="$pct"
  fi
}
main
