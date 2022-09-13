#!/usr/bin/env sh

# iwconfig wlan0 OR iw dev wlan0 link
[[ -z "$(iwgetid -r)" ]] || awk '/^\s*wl/ { print " " int($3 * 100/70) "%" }' /proc/net/wireless
