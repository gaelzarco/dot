#!/usr/bin/env bash

I2C_BUS="2"
CACHE_FILE="/tmp/brightness_cache"

# Initialize cache quickly
[ -f "$CACHE_FILE" ] || echo "50" > "$CACHE_FILE"

# Fast get brightness from cache
get_brightness() {
    cat "$CACHE_FILE" 2>/dev/null || echo "50"
}

# Apply brightness instantly in background
apply_brightness() {
    local value=$1
    echo "$value" > "$CACHE_FILE"
    setsid ddcutil --sleep-multiplier 0.00 --bus "$I2C_BUS" setvcp 10 "$value" >/dev/null 2>&1 &
}

# Send notification immediately
send_notification() {
    local value=$(get_brightness)
    notify-send -e -a "Eve Spectrum" -t 2000 -h int:value:"$value" "Brightness: $value%"
}

# Clamp brightness 0–100
clamp() {
    local val=$1
    [ "$val" -lt 0 ] && echo 0 && return
    [ "$val" -gt 100 ] && echo 100 && return
    echo "$val"
}

# Adjust brightness
adjust_brightness() {
    local change=$1
    local current=$(get_brightness)
    local new_value=$(clamp $((current + change)))
    apply_brightness "$new_value"
#    send_notification
}

# Set brightness
set_brightness() {
    local value=$(clamp "$1")
    apply_brightness "$value"
#    send_notification
}

# Actual read (slower, use only when forced)
get_actual() {
    ddcutil --sleep-multiplier 0.01 --bus "$I2C_BUS" getvcp 10 2>/dev/null | grep -oP 'current value =\s*\K[0-9]+' || get_brightness
}

# Main logic
case "$1" in
    up) adjust_brightness 10 ;;
    down) adjust_brightness -10 ;;
    min) set_brightness 10 ;;
    max) set_brightness 100 ;;
    set) set_brightness "${2:-50}" ;;
    get) get_brightness ;;
    actual) get_actual ;;
    sync)
        ACTUAL=$(get_actual)
        echo "$ACTUAL" > "$CACHE_FILE"
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|min|max|set <value>|get|actual|sync}"
        exit 1
        ;;
esac
