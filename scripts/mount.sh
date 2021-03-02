#!/usr/bin/env bash
#
# This script requires udevil for mounting
# https://github.com/IgnorantGuru/udevil
#
c=$(lsblk -rpo "name,type,fstype,size,mountpoint" | sort | grep 'part\|rom' | \
  awk '$5==""{printf "%s %s %s\n",$1,$3,$4}' | rofi -dmenu -i -p '>' \
  -lines 7 -width 20 -format s | awk '{print $1}')

if [[ $c == /* ]] ;
then
	echo "Mounting: $c"
	out=$(udevil mount -o nosuid,nodev,noexec,noatime $c | awk '{print $4}')
	echo "Mounted: $out"
	nnn $out
else
	echo "Invalid: $c"
fi

