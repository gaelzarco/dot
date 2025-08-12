#!/usr/bin/env bash

sleep 1

# Hide if Music.app isn't running / stopped
if ! pgrep -x Music >/dev/null; then
  sketchybar -m --set music drawing=off
  exit 0
fi
PLAYER_STATE=$(osascript -e 'tell application "Music" to get player state as text')
[[ "$PLAYER_STATE" == "stopped" ]] && { sketchybar --set music drawing=off; exit 0; }

# Fetch fields
title=$(osascript -e 'tell application "Music" to get name of current track')
artist=$(osascript -e 'tell application "Music" to get artist of current track')
album=$(osascript -e 'tell application "Music" to get album of current track')
loved=$(osascript -l JavaScript -e "Application('Music').currentTrack().favorited()")

# Trim helpers
trim() { local s="$1" max="$2"; [[ ${#s} -le $max ]] && echo "$s" || echo "${s:0:$((max-1))}…"; }
[[ -n "$title"  ]] && title="$(trim "$title" 20)"
[[ -n "$artist" ]] && artist="$(trim "$artist" 12)"
[[ -n "$album"  ]] && album="$(trim "$album" 12)"

# Build label from available parts only
parts=()
[[ -n "$title"  ]]  && parts+=("$title")
[[ -n "$artist" ]]  && parts+=("$artist")
[[ -n "$album"  ]]  && parts+=("$album")
label="$(IFS=' - '; echo "${parts[*]}")"

# Icon
icon="⏸"
[[ "$PLAYER_STATE" == "playing" ]] && icon="▶"
[[ "$loved" == "true" ]] && icon="❤"

# Render or hide
if [[ -z "$label" ]]; then
  sketchybar -m --set music drawing=off
else
  sketchybar -m --set music icon="$icon" label="$label" drawing=on
fi
