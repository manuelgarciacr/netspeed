options=$(tmux show -g | grep "@netspeed-max-bps" | awk '{print $1}')

tmux display-message "Zeroing maximum speeds..."

for option in $options; do
    tmux set -g "$option" 0
done