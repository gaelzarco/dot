#!/usr/bin/env bash
set -e

[[ -n $HYPRLAND_DEBUG_CONF ]] && exit 0
USAGE="Import environment variables

Usage: $0 <command>

Commands:
  tmux    import to tmux server
  system  import to systemd and dbus user session
  help    print this help
"

_envs=(
  # must-haves for Wayland
  XDG_RUNTIME_DIR
  WAYLAND_DISPLAY
  DISPLAY
  # xdg
  USERNAME
  XDG_BACKEND
  XDG_CURRENT_DESKTOP
  XDG_SESSION_TYPE
  XDG_SESSION_ID
  XDG_SESSION_CLASS
  XDG_SESSION_DESKTOP
  XDG_SEAT
  XDG_VTNR
  # hyprland
  HYPRLAND_CMD
  HYPRLAND_INSTANCE_SIGNATURE
  # sway
  SWAYSOCK
  # misc
  XCURSOR_SIZE
  # toolkit
  _JAVA_AWT_WM_NONREPARENTING
  QT_QPA_PLATFORM
  QT_WAYLAND_DISABLE_WINDOWDECORATION
  GRIM_DEFAULT_DIR
  # ssh
  SSH_AUTH_SOCK
)

case "$1" in
  system)
    # copies named vars from current env into dbus + systemd --user
    dbus-update-activation-environment --systemd "${_envs[@]}"
    ;;
  tmux)
    # ensure a server exists
    tmux start-server
    for v in "${_envs[@]}"; do
      [[ -n ${!v} ]] && tmux set-environment -g "$v" "${!v}"
    done
    ;;
  help)
    printf "%s\n" "$USAGE"; exit 0;;
  *)
    echo "operation required"
    echo "use \"$0 help\" to see usage"; exit 1;;
esac
