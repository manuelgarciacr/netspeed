#!/usr/bin/env bash

# Trim and filter data
trim()
{
	local new_array=()
	local elem
	
	for elem in "${interfaces[@]}"; do
	    device=$(echo $elem | xargs)

		if exist_in_array "new_array" "$device"; then
			continue
		fi
	    if [ -z "$device" ]; then
	        continue
	    fi

		new_array+=("$device")
	done

	interfaces=("${new_array[@]}")
}

interfaces()
{
	interfaces="$(tmux show-option -gqv '@netspeed-interfaces')"
	IFS=$' \t\n'
	mapfile -d ' ' -t interfaces < <(printf "%s" "$interfaces")

	trim "interfaces"
}