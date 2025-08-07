#!/usr/bin/env bash

focused=$(aerospace list-workspaces --focused)
sketchybar --set space_indicator label="$focused"
