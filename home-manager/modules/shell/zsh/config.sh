# Start Tmux automatically if not already running. No Tmux in TTY
if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

# Start UWSM
if uwsm check may-start >/dev/null && uwsm select; then
  exec systemd-cat -t uwsm_start uwsm start default
fi
