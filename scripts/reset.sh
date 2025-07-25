options=$(tmux show -g | grep "@netspeed" | awk '{print $1}')
key_max=$(tmux show -gqv @netspeed-max-speed-reset-key)
key_stop=$(tmux show -gqv @netspeed-stop-key)

tmux set -g @netspeed-stop true
tmux unbind-key "$key_max"
tmux unbind-key "$key_stop"

pids=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{print $2}')
pids_message=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{printf "%s, ", $2}' | sed 's/,\s*$//' | sed 's/\(.*\),/\1 y/')

while [ -n "$pids" ]; do
    tmux display-message "Removing previous executions... $pids_message"
    tmux run -b "kill -9 $pids &"
    pids=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{print $2}')
done

for option in $options; do
    tmux set -gu "$option"
done

rm -r ~/.tmux/plugins/netspeed
rm -r ~/.tmux/plugins/tmux2k

