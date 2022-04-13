#!/usr/bin/env bash
#
# This script requires udisks for mounting
# https://freedesktop.org/wiki/Software/udisks
#
s=$(lsblk -rpo "name,type,fstype,size,mountpoint" | sort | grep 'part\|rom' | \
  awk '$5==""{printf "%s %s %s\n",$1,$3,$4}' | rofi -dmenu -mesg Mount -i -p '>' \
  -lines 7 -width 24 -format s | awk '{print $1}')

if [[ $s == /* ]] ;
then
	echo "Mounting: $s"
	out=$(udisksctl mount -b $s | awk '{print $4}')
	echo "Mounted: $out"
	nnn $out
else
	echo "Invalid: $s"
fi
