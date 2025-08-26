#!/bin/bash

M1DDC="/opt/homebrew/bin/m1ddc"
DDC_DISPLAY="${DDC_DISPLAY:-}"
WIDTH=100
HIDE_LOCK_FILE="/tmp/brightness_hide_lock"

detect_display() {
  for d in 1 2 3 4 5 6; do
    out=$("$M1DDC" display "$d" get luminance 2>/dev/null) || continue
    [[ "$out" =~ ^[0-9]+$ ]] && { echo "$d"; return; }
  done
}

brightness_change() {
  # Only if we actually have an external DDC display
  [[ -z "$DDC_DISPLAY" ]] && DDC_DISPLAY="$(detect_display)"
  [[ -z "$DDC_DISPLAY" ]] && exit 0

  # Only react to our own DDC-triggered events, not the built-in panel
  [[ "$SRC" != "ddc" ]] && exit 0

  # clear label while the slider is visible
  sketchybar --set brightness_icon label=""

  sketchybar --set "$NAME" slider.percentage="$INFO" \
             --animate tanh 30 --set "$NAME" slider.width="$WIDTH"
  pkill -f "brightness_hide_process" 2>/dev/null
  ( exec -a brightness_hide_process bash -c "
      sleep 2
      FINAL=\$(sketchybar --query $NAME | jq -r '.slider.percentage')
      if [[ \"\$FINAL\" == \"$INFO\" ]]; then
        sketchybar --animate tanh 30 --set $NAME slider.width=0
        sketchybar --set brightness_icon label=\"${INFO}%\"
      fi
    "
  ) &
}

mouse_clicked() {
  [[ -x "$M1DDC" ]] || exit 0
  [[ -z "$DDC_DISPLAY" ]] && DDC_DISPLAY="$(detect_display)"
  [[ -z "$DDC_DISPLAY" ]] && exit 0

  "$M1DDC" display "$DDC_DISPLAY" set luminance "$PERCENTAGE" >/dev/null 2>&1
  sketchybar --trigger brightness_change SRC=ddc INFO="$PERCENTAGE"
}

mouse_entered() {
  sketchybar --set "$NAME" slider.knob.drawing=on \
             --set brightness_icon label=""
}

mouse_exited()  { sketchybar --set "$NAME" slider.knob.drawing=off; }

case "$SENDER" in
  "brightness_change") brightness_change ;;
  "mouse.clicked")     mouse_clicked    ;;
  "mouse.entered")     mouse_entered    ;;
  "mouse.exited")      mouse_exited     ;;
esac
