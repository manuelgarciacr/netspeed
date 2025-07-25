stop=$(tmux show -gqv @netspeed-stop)
if [ -n "$stop" ]; then
	tmux display-message "Resuming netspeed..."
	tmux set -gu @netspeed-stop
else
	tmux set -g @netspeed-stop true
fi

