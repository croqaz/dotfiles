#!/usr/bin/env sh

# Source: https://idnt.net/en-US/kb/941772
while :; do
  # Get the first line with aggregate of all CPUs
  cpu_now=($(head -n1 /proc/stat))
  # Get all columns but skip the first (which is the "cpu" string)
  cpu_sum="${cpu_now[@]:1}"
  # Replace the column seperator (space) with +
  cpu_sum=$((${cpu_sum// /+}))
  # Get the delta between two reads
  cpu_delta=$((cpu_sum - cpu_last_sum))
  # Get the idle time Delta 
  cpu_idle=$((cpu_now[4] - cpu_last[4]))
  # Calc time spent working
  cpu_used=$((cpu_delta - cpu_idle))
  # Calc percentage
  cpu_usage=$((9 * cpu_used / cpu_delta))

  # Keep this as last for our next read 
  cpu_last=("${cpu_now[@]}")
  cpu_last_sum=$cpu_sum

  echo "CPU=$cpu_usage"

  printf "🅲="
  case $cpu_usage in
	0) printf '⓿' ;;
	1) printf '❶' ;;
	2) printf '❷' ;;
	3) printf '❸' ;;
	4) printf '❹' ;;
	5) printf '❺' ;;
	6) printf '❻' ;;
	7) printf '❼' ;;
	8) printf '❽' ;;
	9) printf '❾' ;;
  esac
  printf "\n"

  echo "#d79921"

  # Wait before the next read 
  sleep 2
done
