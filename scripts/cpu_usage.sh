#!/usr/bin/env sh

# Cache in tmpfs to improve speed and reduce SSD load
cache=/tmp/cpu_bars_cache

# id | total | idle
stats=$(awk '/cpu[0-9]+/ {printf "%d %d %d\n", substr($1,4), ($2 + $3 + $4 + $5), $5}' /proc/stat)
[ ! -f $cache ] && echo "$stats" > "$cache"
old=$(cat "$cache")
printf "🅲="

echo "$stats" | while read -r row; do
	id=${row%% *}
	rest=${row#* }
	total=${rest%% *}
	idle=${rest##* }
	# Numbers from 0 to 8
	printf "$(echo "$old" | awk '{if ($1 == id)
		printf "%d\n", (1 - (idle - $3)  / (total - $2))*100 / 12.5}' \
		id="$id" total="$total" idle="$idle")"
done; printf "\\n"

echo "$stats" > "$cache"
