#!/bin/bash
pause_mpvpaper() {
    echo '{ "command": ["set_property", "pause", true] }' | socat - "/tmp/mpvsocket" 
}
unpause_mpvpaper() {
    echo '{ "command": ["set_property", "pause", false] }' | socat - "/tmp/mpvsocket"
}
# Monitor gamemode status
while true; do
    if pgrep -x "gamemoded" > /dev/null; then
        pause_mpvpaper
        while pgrep -x "gamemoded" > /dev/null; do
            sleep 1
        done
        unpause_mpvpaper
    fi
    sleep 1
done
