#!/usr/bin/env bash

I2C_BUS=14
CACHE=/tmp/brightness_cache
PIDFILE=/tmp/brightness_debounce.pid
MON_NAME_CACHE=/tmp/monitor_name_cache

STEP=10
DEBOUNCE=1
APP_NAME="Spectrum One Monitor"   # default; will be overwritten by cached hyprctl name
SYNC_HINT="spectrum_one"
NOTIFY_MS=2000

init_monitor_name() {
  # read existing cached name (if any)
  local cached=""
  [ -s "$MON_NAME_CACHE" ] && cached="$(cat "$MON_NAME_CACHE")"

  # get current focused monitor model (prefer jq; fallback to awk)
  local name current short
  name="$(hyprctl -j monitors 2>/dev/null \
            | jq -r 'map(select(.focused==true))[0].model // empty' 2>/dev/null)" || true
  if [ -z "$name" ]; then
    # fallback: plain text parse
    name="$(hyprctl monitors 2>/dev/null | awk '
      /^Monitor /{blk=1; foc=0}
      $1=="focused:" && $2=="yes"{foc=1}
      blk && $1=="model:" && foc{print $2; exit}
    ')"
  fi

  short="$(printf '%s' "$name" | awk '{print $NF}')"
  [ -z "$short" ] && short="Spectrum One Monitor"

  # update cache if changed
  if [ "$short" != "$cached" ]; then
    printf '%s' "$short" > "$MON_NAME_CACHE"
  fi

  APP_NAME="$short"
}

read_cache() { cat "$CACHE" 2>/dev/null || echo 50; }
clamp() { v=$1; [ "$v" -lt 0 ] && echo 0 && return; [ "$v" -gt 100 ] && echo 100 && return; echo "$v"; }

# Initialize cache from current monitor value, floored to nearest 10
init_cache() {
  [ -f "$CACHE" ] && return
  cur=$(ddcutil --sleep-multiplier 0.00 --bus "$I2C_BUS" getvcp 10 2>/dev/null \
        | grep -oP 'current value =\s*\K[0-9]+')
  [ -z "$cur" ] && cur=50
  cur=$(clamp "$cur")
  cur=$(( (cur/10)*10 ))   # floor to nearest 10
  printf "%d" "$cur" > "$CACHE"
}

cancel_pending() {
  if [ -f "$PIDFILE" ]; then
    pid=$(<"$PIDFILE")
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    fi
    rm -f "$PIDFILE" 2>/dev/null || true
  fi
}

schedule_write() {
  cancel_pending
  (
    sleep "$DEBOUNCE"
    new=$(read_cache)
    setsid ddcutil --sleep-multiplier 0.00 --bus "$I2C_BUS" setvcp 10 "$new" >/dev/null 2>&1
    rm -f "$PIDFILE" 2>/dev/null || true
  ) &
  echo "$!" > "$PIDFILE"
}

update_local() {
  new=$(clamp "$1")
  printf "%d" "$new" > "$CACHE"
  notify-send -e -a "$APP_NAME" -t "$NOTIFY_MS" \
    -h string:x-canonical-private-synchronous:"$SYNC_HINT" \
    -h int:value:"$new" "$APP_NAME"
  pkill -RTMIN+5 waybar 2>/dev/null || true
  schedule_write
}

write_now() {
  cancel_pending
  new=$(clamp "$1")
  printf "%d" "$new" > "$CACHE"
  notify-send -e -a "$APP_NAME" -t "$NOTIFY_MS" \
    -h string:x-canonical-private-synchronous:"$SYNC_HINT" \
    -h int:value:"$new" "$APP_NAME"
  pkill -RTMIN+5 waybar 2>/dev/null || true
  setsid ddcutil --sleep-multiplier 0.00 --bus "$I2C_BUS" setvcp 10 "$new" >/dev/null 2>&1 &
}

# init
init_monitor_name
init_cache

case "$1" in
  up)   update_local $(( $(read_cache) + STEP )) ;;
  down) update_local $(( $(read_cache) - STEP )) ;;
  min)  update_local 10 ;;
  max)  update_local 100 ;;
  set)  update_local "${2:-50}" ;;
  get)  read_cache ;;
  sync)
        ACTUAL=$(ddcutil --sleep-multiplier 0.00 --bus "$I2C_BUS" getvcp 10 2>/dev/null \
                 | grep -oP 'current value =\s*\K[0-9]+' || read_cache)
        write_now "$ACTUAL"
        ;;
  *) echo "Usage: $0 {up|down|min|max|set <v>|get|sync}"; exit 1 ;;
esac
