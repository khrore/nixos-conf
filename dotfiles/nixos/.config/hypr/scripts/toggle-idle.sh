#!/usr/bin/env bash
# Toggle hypridle for presentation mode
# Vim-style idle prevention toggle (Super+Shift+I)

if pgrep -x hypridle > /dev/null; then
    pkill hypridle
    notify-send -u low "Idle Prevention" "Enabled (hypridle stopped)" -t 2000
else
    hypridle &
    notify-send -u low "Idle Prevention" "Disabled (hypridle started)" -t 2000
fi
