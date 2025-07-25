stop=$(tmux show -gqv @netspeed-stop)
if [ -n "$stop" ]; then
	tmux set -gu @netspeed-stop
	tmux display-message "Resuming netspeed..."
else
    tmux set -g @netspeed-stop true
    tmux display-message "Stopping netspeed..."
    
    options=$(tmux show -g | grep -E "^@netspeed-up|^@netspeed-down" | awk '{print $1}')
    for option in $options; do
    	tmux set -g "$option" ""
    done
fi

