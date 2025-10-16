#!/usr/bin/env bash
set -euo pipefail

frames=( "∘" "∙" "•" "●" "•" "∙" )
idx=$(( $(date +%s) % ${#frames[@]} ))
spin="${frames[$idx]}"

status="$(playerctl status 2>/dev/null || echo Stopped)"
meta="$(playerctl metadata --format '{{title}}::{{artist}}' 2>/dev/null || true)"
[ -z "$meta" ] && meta=""

case "$status" in
  Playing)
    echo "{\"text\":\"$spin $meta\",\"class\":\"playing\",\"tooltip\":\"$status\"}"
    ;;
  Paused)
    echo "{\"text\":\"⏸ $meta\",\"class\":\"paused\",\"tooltip\":\"$status\"}"
    ;;
  *)
    echo "{\"text\":\"\",\"class\":\"stopped\",\"tooltip\":\"$status\"}"
    ;;
esac
