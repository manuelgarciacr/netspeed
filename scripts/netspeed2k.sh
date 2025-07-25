#!/usr/bin/env bash

OUTPUT="@netspeed-down-max-eno1 @netspeed-up-eno1"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
	tmux set -g @netspeed-date-2k "$(echo $(date))"
	$current_dir/../../netspeed/scripts/netspeed.sh
	output=""
	
	for option in $OUTPUT; do
    	output="$output$(tmux show -gqv "$option")"
    done
    
    echo "$output"
}

main
