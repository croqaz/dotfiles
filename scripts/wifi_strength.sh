#!/usr/bin/env sh

# iwconfig wlan0 OR iw dev wlan0 link
[[ -z "$(iwgetid -r)" ]] || awk '/^\s*wl/ { print "&#8711;<span font_family=\"Hack\">" int($3 * 100/70) "%</span>" }' /proc/net/wireless
