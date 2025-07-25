#!/usr/bin/env bash

OUTPUT="@netspeed-down-eno1 @netspeed-down-wlp3s0"

main() {
	tmux set -g @netspeed-debug-2k "$(echo $(date))"
	output=""
	
	for option in $OUTPUT; do
    	output="$output$(tmux show -gqv "$option" | sed 's/^[[:space:]]*//')"
    done

    echo "$output"
}

main