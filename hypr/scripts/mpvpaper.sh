#!/bin/bash
# Dependencies: mpvpaper 
# Ensure to change DP-4 to proper monitor output

mpvpaper -o "--input-ipc-server=/tmp/mpvsocket no-audio --loop-file=inf" DP-1 "$HYPR_WALLVIDEO"
