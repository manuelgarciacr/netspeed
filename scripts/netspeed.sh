#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/utils.sh"
source "$current_dir/interfaces.sh"

save_value()
{
    stop=$(tmux show -gqv @netspeed-stop)
	hiden=$(tmux show -gqv @netspeed-hide-max-speed)
	down_icon=$(tmux show-option -gqv @netspeed-down-icon); [ -z "$down_icon" ] && down_icon=""
	up_icon=$(tmux show-option -gqv @netspeed-up-icon); [ -z "$up_icon" ] && up_icon=""
	
	if [ -n "$stop" ]; then
		return
	fi

	max="$(tmux show-option -gqv "@netspeed-max-bps-$OPTION-$DEVICE")"
    
	if awk -v bps="$BPS" -v max="$max" 'BEGIN { exit !(bps > max) }'; then
		tmux set -g "@netspeed-max-bps-$OPTION-$DEVICE" $BPS
		max="$BPS"
	fi
	
	declare -n icon=${OPTION}_icon
	
	value="$(printf '%7.2f %-4s' $(bps_to_unit "$BPS"))"
	if [ -z "$hiden" ]; then
		value="$value(max $(printf '%.2f %s' $(bps_to_unit "$max")))"
	fi
	
	tmux set -g "@netspeed-$OPTION-$DEVICE" " $icon $DEVICE$value"

	if [ "$OPTION" == "down" ]; then
		up="$(tmux show -gqv "@netspeed-up-$DEVICE")"
		tmux set -g "@netspeed-updown-$DEVICE" "$up $icon$value"
	fi
}

calculate()
{
    FECHA_INI=$(date +%s%N)
    BYTES1=$(cat /sys/class/net/$DEVICE/statistics/$RXTX)
    sleep 1
    FECHA_FIN=$(date +%s%N)
    BYTES2=$(cat /sys/class/net/$DEVICE/statistics/$RXTX)
	SEC=$(awk -v fecha_fin="$FECHA_FIN" -v fecha_ini="$FECHA_INI" 'BEGIN { printf "%.3f\n", (fecha_fin - fecha_ini) / 1000000000 }')
	BPS=$(awk -v bytes2="$BYTES2" -v bytes1="$BYTES1" -v sec="$SEC" 'BEGIN { printf "%7.2f\n", (bytes2 - bytes1) / sec * 8 }')
	
	maxsec=$(tmux show -gqv @netspeed-debug-sec)
	if (( $(echo "$SEC $maxsec" | awk '{print ($1 > $2)}') )); then
  		tmux set -g @netspeed-debug-sec "$SEC"
	fi
	
#    BYTES1=$(cat /sys/class/net/$DEVICE/statistics/$RXTX)
#    sleep 1
#    BYTES2=$(cat /sys/class/net/$DEVICE/statistics/$RXTX)
#    BPS=$(awk -v bytes2="$BYTES2" -v bytes1="$BYTES1" 'BEGIN { printf "%7.2f\n", (bytes2 - bytes1) / 8 }')

	save_value
}

loop() 
{
    for DEVICE in "${interfaces[@]}"; do
		OPTION="up"
		RXTX="tx_bytes"
		
		calculate &
		
		OPTION="down"
		RXTX="rx_bytes"
		
		calculate &
		
		wait
	done
}

main()
{	
	interfaces
	
	#declare -p interfaces
	
    stop=$(tmux show -gqv @netspeed-stop)
    
	if [ -n "$stop" ]; then
		return
	fi
	
	if [[ "$1" == "loop" ]]; then
		tmux set -g @netspeed-debug-loop "$(echo $(date)) pid: $(echo $$)"
		while true; do
		    stop=$(tmux show -gqv @netspeed-stop)
		    
			if [ -z "$stop" ]; then
				loop
			fi
		done
	else
		tmux set -g @netspeed-debug-executution "$(echo $(date)) pid: $(echo $$)"
		loop
	fi
}

main "$@"