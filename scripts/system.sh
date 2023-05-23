#!/usr/bin/env bash

c=$(echo -e "\uf023 Lock\n\uf08b Logout\n\uf7ae Suspend\n\uf01e Reboot\n\uf011 Shutdown" | rofi \
  -dmenu -i -no-custom -p '>' -lines 6 -width 20 -format s | awk '{print $2}')
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
