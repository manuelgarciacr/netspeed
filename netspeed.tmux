#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/scripts/utils.sh

main()
{
	tmux set -g @netspeed-date "$(echo $(date))"
	binding_keys
	pids=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{print $2}')
	pids_message=$(ps aux | grep 'bash.*netspeed.sh.*' | grep -v grep | awk '{printf "%s, ", $2}' | sed 's/,\s*$//' | sed 's/\(.*\),/\1 y/')
	
	if [ -n "$pids" ]; then
	    tmux display-message "Removing previous executions... $pids_message"
		tmux run -b "kill -9 $pids &"
	fi
	tmux set -g @netspeed-pid-tmux $(echo $$)
	tmux run -b "nohup ~/.tmux/plugins/netspeed/scripts/netspeed.sh loop &"
}

main

