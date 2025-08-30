#!/usr/bin/env bash

cpu_pct() {
  local sum cores
  sum=$(ps -A -o %cpu | awk '{s+=$1} END{printf "%.1f", s+0}')
  cores=$(sysctl -n hw.ncpu)
  awk -v s="$sum" -v c="$cores" 'BEGIN{printf "%.0f", (s/c)}'
}

gpu_pct() {
  export LANG=C LC_ALL=C
  local dump pct
  dump="$(ioreg -r -c AGXAccelerator -d4 2>/dev/null)"

  pct="$(printf '%s\n' "$dump" | grep -oE '"Device Utilization %"[[:space:]]*=[[:space:]]*[0-9.]+' | head -n1 | awk -F= '{gsub(/[[:space:]]/,"",$2); print int($2+0.5)}')"
  if [[ -z "$pct" ]]; then
    pct="$(printf '%s\n' "$dump" | grep -oE '"Renderer Utilization %"[[:space:]]*=[[:space:]]*[0-9.]+' | head -n1 | awk -F= '{gsub(/[[:space:]]/,"",$2); print int($2+0.5)}')"
  fi
  if [[ -z "$pct" ]]; then
    pct="$(printf '%s\n' "$dump" | grep -oE '"Tiler Utilization %"[[:space:]]*=[[:space:]]*[0-9.]+' | head -n1 | awk -F= '{gsub(/[[:space:]]/,"",$2); print int($2+0.5)}')"
  fi

  echo "$pct"
}

mem_pct() {
  local total pagesize anon wired comp used_pages usedb
  total=$(sysctl -n hw.memsize)
  pagesize=$(sysctl -n hw.pagesize)

  anon=$(vm_stat | awk '/Anonymous pages/ {gsub("\\.","",$3); print $3}')
  wired=$(vm_stat | awk '/Pages wired/ {for(i=1;i<=NF;i++) if($i ~ /^[0-9.]+$/){gsub("\\.","",$i); print $i; exit}}')
  comp=$(vm_stat | awk '/occupied by compressor/ {gsub("\\.","",$5); print $5}')

  : "${anon:=0}"; : "${wired:=0}"; : "${comp:=0}"

  used_pages=$(( anon + wired + comp ))
  usedb=$(( used_pages * pagesize ))
  awk -v u="$usedb" -v t="$total" 'BEGIN{printf "%.0f",(u*100/t)}'
}

set_item() {
  local name="$1" pct="$2" icon="$3" col
  if [[ -z "$pct" ]]; then
    sketchybar --set "$name" drawing=off
    return
  fi
  sketchybar --set "$name" drawing=on icon="$icon" label="${pct}%"
}

case "$NAME" in
  cpu_usage) set_item "$NAME" "$(cpu_pct)" "" ;;
  gpu_usage) set_item "$NAME" "$(gpu_pct)" "󰢮" ;;
  mem_usage) set_item "$NAME" "$(mem_pct)" "󰍛" ;;
esac
