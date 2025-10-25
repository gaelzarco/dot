#!/bin/bash
case "$1" in
    "volup")
        pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'no' && pactl set-sink-volume @DEFAULT_SINK@ +5.0%
        ;;
    "voldown")
        pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'no' && pactl set-sink-volume @DEFAULT_SINK@ -5.0%
        ;;
    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

DEVICE_NAME=$(pactl list sinks | grep -A1 "Name: $(pactl get-default-sink)" | grep "Description:" | cut -d' ' -f2- | cut -c1-50 )

# Check mute state
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then
    VOLUME=0
else
    VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o "[0-9]\+" | sed -n 2p)
fi

notify-send -e -a "$DEVICE_NAME" -t 2000 "$DEVICE_NAME" -h string:x-canonical-private-synchronous:volume -h int:value:${VOLUME:-0}
