ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm.dd.yyyy"

export ARCHFLAGS="-arch x86_64"
export TERMINAL=ghostty

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# alias t = 'tmux a -t x1 || tmux new-session -s "x1"'

PATH=~/.console-ninja/.bin:$PATH
PATH=~/.config/bin:$PATH

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -s "/Users/xarco/.bun/_bun" ] && source "/Users/xarco/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GPG_TTY=$(tty)

autoload -U compinit; compinit

# Hyprland: tmux autostart -> win1 runs STAT_CMD, win2 shell
STAT_CMD="${TMUX_STAT_CMD:-btop}"
command -v "$STAT_CMD" >/dev/null || STAT_CMD="btop"

if command -v tmux &>/dev/null && [ -z "$TMUX" ] && { [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
  if tmux has-session -t x0 2>/dev/null; then
    exec tmux attach -t x0
  else
    tmux new-session -d -s x0 -n sesh "$STAT_CMD"
    tmux new-window  -t x0:2 -n term
    exec tmux attach -t x0 \; select-window -t 1
  fi
fi
