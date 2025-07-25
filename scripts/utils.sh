#!/usr/bin/env bash

array_to_string()
{
	local -n __array=$1
	local __str=""
	local __idx
	
	for __idx in "${!__array[@]}"; do
		elem="$(echo "${__array[$__idx]}" | xargs)"
		if [ -n "$elem" ]; then
		   	if [ -n "$__str" ]; then
		       	__str="$__str,"
		    fi
		    __str="$__str$elem"
		fi
	done
	
	echo "$__str"
}

error()
{
	tmux display-message "#[fg=white,bg=red]Error $2 at: $1"
	#run-shell "exit $2"
	exit $2
}

exist_in_array() {
    local -n __array=$1
    local __elem

    for __elem in "${__array[@]}"; do
        if [[ "$__elem" == "$2" ]]; then
            return 0
        fi
    done
    return 1
}

delete_from_array() {
    local -n __array=$1
    local __new_array=()
    local __elem

	for __elem in "${__array[@]}"; do
        if [[ "$__elem" != "$2" ]]; then
            __new_array+=("$__elem")
        fi
    done

    __array=("${__new_array[@]}")
}

bps_to_unit()
{
	local __BPS="$1"

	if awk -v bps="$__BPS" 'BEGIN { exit !(bps > 1000) }'; then
	    KBPS=$(awk -v bps="$__BPS" 'BEGIN { printf "%7.2f\n", bps / 1000 }')
	else
	    echo "$__BPS bps"
	    return
	fi

	if awk -v kbps="$KBPS" 'BEGIN { exit !(kbps > 1000) }'; then
	    MBPS=$(awk -v kbps="$KBPS" 'BEGIN { printf "%7.2f\n", kbps / 1000 }')
	else
	    echo "$KBPS Kbps"
	    return
	fi

	if awk -v mbps="$MBPS" 'BEGIN { exit !(mbps > 1000) }'; then
	    echo $(awk -v mbps="$MBPS" 'BEGIN { printf "%7.2f Gbps\n", mbps / 1000 }')
	else
	    echo $MBPS "Mbps"
	fi
}

binding_keys()
{
	CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	key_max=$(tmux show -gqv @netspeed-max-speed-reset-key); [ -z "$key_max" ] && key_max="M"
	key_hide=$(tmux show -gqv @netspeed-max-speed-hide-key); [ -z "$key_hide" ] && key_hide="H"
	key_stop=$(tmux show -gqv @netspeed-stop-key); [ -z "$key_stop" ] && key_stop="S"

	tmux bind-key -N "netspeed reset max speed" "$key_max" run-shell "$CURRENT_DIR/reset_max_speed.sh"
	tmux bind-key -N "netspeed hide max speed" "$key_hide" run-shell "$CURRENT_DIR/hide_max_speed.sh"
	tmux bind-key -N "netspeed stop" "$key_stop" run-shell "$CURRENT_DIR/stop.sh"
}

