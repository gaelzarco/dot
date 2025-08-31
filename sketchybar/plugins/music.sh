#!/usr/bin/env bash

TITLE_MAX=20
ARTIST_MAX=12
ALBUM_MAX=12

hide()  { sketchybar -m --set music drawing=off; }
music() { osascript -e "tell application \"Music\" to $*"; }
trim()  { local s="$1" max="$2"; [[ ${#s} -gt $max ]] && printf '%s…' "${s:0:max-1}" || printf '%s' "$s"; }
add()   { local s="$1"; [[ -n "$s" ]] && { [[ -n "$label" ]] && label+=" - "; label+="$s"; }; }

pgrep -x Music >/dev/null || { hide; exit 0; }
state=$(music 'get player state as text')
[[ "$state" == "stopped" ]] && { hide; exit 0; }

title=$(music 'get name of current track')
artist=$(music 'get artist of current track')
# album=$(music 'get album of current track')

[[ -n "$title"  ]] && title="$(trim "$title"  "$TITLE_MAX")"
[[ -n "$artist" ]] && artist="$(trim "$artist" "$ARTIST_MAX")"
# [[ -n "$album"  ]] && album="$(trim "$album"  "$ALBUM_MAX")"

label=""
add "$title"; add "$artist"; # add "$album"

icon="⏸"
[[ "$state" == "playing" ]] && icon="▶"

# --- render ---
[[ -n "$label" ]] && sketchybar -m --set music icon="$icon" label="$label" drawing=on || hide
