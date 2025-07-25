hide=$(tmux show -gqv @netspeed-hide-max-speed)

if [ -n "$hide" ]; then
	tmux set -gu @netspeed-hide-max-speed
	tmux display-message "Showing maximum speeds..."
else
    tmux set -g @netspeed-hide-max-speed true
    tmux display-message "Hidind maximum speeds..."
fi
