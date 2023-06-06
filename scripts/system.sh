#!/usr/bin/env bash

c=$(echo -e " Lock\n Logout\n Suspend\n󰑓 Reboot\n󰐥 Shutdown" | rofi \
  -font 'Hack Nerd Font 16' -dmenu -i -no-custom -p '>' -lines 5 -width 12 -format s | awk '{print $2}')
echo $c

case $c in
  Lock)
    $HOME/.local/scripts/lock.sh
  ;;

  Logout)
    bspc quit
  ;;

  Suspend)
    loginctl suspend
  ;;

  Reboot)
    loginctl reboot
  ;;

  Shutdown)
    loginctl poweroff
  ;;

  *) echo "Invalid: $c"; exit 1 ;;
esac
