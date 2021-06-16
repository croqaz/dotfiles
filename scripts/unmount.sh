#!/usr/bin/env bash
#
# This script requires udevil for un-mounting
# https://github.com/IgnorantGuru/udevil
#
s=$(df -ahT | grep '^/' | awk ' { print $1"\t"$2"\t"$3"\t"$7 }' | \
  rofi -dmenu -mesg Unmount -i -p '>' -lines 7 -format s | awk '{print $1}')

if [[ $s == /* ]] ;
then
	echo "Un-mounting: $s"
	udevil umount $s
else
	echo "Invalid: $s"
fi
