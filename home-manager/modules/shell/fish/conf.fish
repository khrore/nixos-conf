# Coloring Catppuccin theme
# disable fish hello
set -g fish_greeting ""

# Start Tmux automatically if not already running. No Tmux in TTY
if test -z "$TMUX"; and test -n "$DISPLAY"
    tmux attach-session -t default; or tmux new-session -s default
end
