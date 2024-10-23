#!/bin/bash
# Dependencies grim, magick, hyprlock

# Screenshot current screen and store it in cache
grim -s 1.5 -l 0 ~/.cache/screenlock.png

# Scale image resolution down for performance, apply blur, resize, and save 
# Be sure to set hyprlock to look for wallpaper in ~/.cache/screenlock.png
magick ~/.cache/screenlock.png -scale 20% -blur 0x2 -modulate 30,100,100 -resize 200% ~/.cache/screenlock.png

# Call hyprlock after the 
hyprlock
