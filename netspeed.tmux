#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/scripts/utils.sh
source $current_dir/scripts/interfaces.sh

main()
{
	interfaces
	
	for DEVICE in "${interfaces[@]}"; do
		bytes=$(cat /sys/class/net/$DEVICE/statistics/rx_bytes)
		
		if [ -z "$bytes" ]; then
			error="$error\"$device\", "
		fi
	done

	if [ -n "$error" ];then
		error="$(echo "$error" | sed 's/,\s*$//' | sed 's/\(.*\),/\1 y/'): Interfaces without data"
		delay=$(( $(tmux show -gqv display-time) / 1000 + 1))
		style=$(tmux show -gqv message-style)
		
		tmux set-option -g message-style "bg=default"
		tmux display-message "#[bg=red,fg=white]$error #[bg=default]"
		
		sleep "$delay"
		
		tmux set-option -g message-style "$style"
	fi

	tmux set -g @netspeed-debug-tmux "$(echo $(date)) pid: $(echo $$)"
	tmux set -gu @netspeed-stop
	
	binding_keys
	
	pids=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{print $2}')
	pids_message=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{printf "%s, ", $2}' | sed 's/,\s*$//' | sed 's/\(.*\),/\1 y/')
	
	if [ -n "$pids" ]; then
	    tmux display-message "Removing previous executions... $pids_message"
		tmux run -b "kill -9 $pids &"
	fi
	
	tmux run -b "nohup ~/.tmux/plugins/netspeed/scripts/netspeed.sh loop &"
}

main