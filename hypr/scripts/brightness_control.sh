#!/bin/bash

BRIGHTNESS_FILE="/tmp/previous_brightness"

case "$1" in
    save)
        ddcutil getvcp 10 | awk -F'[=,]' '{print $2}' | tr -d ' '
        ddcutil setvcp 10 10
        ;;
    restore)
        if [ -f "$BRIGHTNESS_FILE" ]; then
            previous=$(cat "$BRIGHTNESS_FILE")
            ddcutil setvcp 10 "$previous"
            rm "$BRIGHTNESS_FILE"
        else
            ddcutil setvcp 10 50  # fallback to 50 if no saved value
        fi
        ;;
esac
