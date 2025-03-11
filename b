#!/usr/bin/env bash

gum style \
  --foreground 12 \
  --align center --width 60 --margin "1 1" \
  '░▒▓███████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓███████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░ ░▒▓█████████████▓▒░'

gum spin --show-output --spinner minidot --title "Updating brew..." -- brew update
printf "\n"

OUTDATED=$(gum spin --show-output --spinner minidot --title "Checking for outdated brew packages" -- brew outdated)

if [[ -n "$OUTDATED" ]]; then
  echo "$OUTDATED"
  gum confirm --selected.background=2 --selected.foreground=0 "Upgrade the outdated formulae above?" && brew upgrade
  printf "\n"
  brew cleanup --prune=all
  printf "\n"
else
  echo "All brew packages are up to date."
  printf "\n"
fi

echo "You are all set."
