#!/usr/bin/env bash

c=$(echo -e "\uF023 Lock\n\uF2F5 Logout\n\uF7AE Suspend\n\uF2F9 Reboot\n\uF011 Shutdown" | rofi \
  -font 'la-solid-900 16' -dmenu -i -no-custom -p '>' -lines 6 -width 12 -format s | awk '{print $2}')
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
