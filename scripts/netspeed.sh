#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/utils.sh"
source "$current_dir/interfaces.sh"
interfaces=$(tmux show -gqv @netspeed-interfaces)
IFS=$' \t\n'
mapfile -d ' ' -t interfaces < <(printf "%s" "$interfaces")

outputs()
{
	tmux set -g "@netspeed-down-$DEVICE" "󰅢  $DEVICE${value_down}"
	tmux set -g "@netspeed-up-$DEVICE" "󰅧  $DEVICE${value_up}"
	tmux set -g "@netspeed-down-max-$DEVICE" "󰅢  $DEVICE${value_down}${max_down}"
	tmux set -g "@netspeed-up-max-$DEVICE" "󰅧  $DEVICE${value_up}${max_up}"	
}

save_value()
{
    max="$(tmux show-option -gqv "@netspeed-max-bps-$OPTION-$DEVICE")"
    
    if awk -v bps="$BPS" -v max="$max" 'BEGIN { exit !(bps > max) }'; then
    	tmux set -g "@netspeed-max-bps-$OPTION-$DEVICE" $BPS
    	max="$BPS"
	fi
	
	printf -v "value_$OPTION" "$(printf '%7.2f %-4s' $(bps_to_unit "$BPS"))"
	printf -v "max_$OPTION" "(max $(printf '%.2f %s' $(bps_to_unit "$max")))"
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

	save_value
}

loop() 
{
    for DEVICE in "${interfaces[@]}"; do
		OPTION="down"
		RXTX="rx_bytes"
		
		calculate
		
		OPTION="up"
		RXTX="tx_bytes"
		
		calculate
		outputs
	done
}

main()
{	
	#declare -p interfaces
	stop=$(tmux show -gqv @netspeed-stop)

	if [ -n "$stop" ]; then
		stopping "$stop"
		return
	fi

	tmux set -g @netspeed-date-stop "$stop$(echo $(date))"

	if [[ "$1" == "loop" ]]; then
		tmux set -g @netspeed-pid-loop echo $$
		
		while true; do
			stop=$(tmux show -gqv @netspeed-stop)
			if [ -n "$stop" ]; then
				break
			fi
			loop
			sleep 2
		done
	else
		tmux set -g @netspeed-pid echo $$
		loop
	fi
}

main "$@"


