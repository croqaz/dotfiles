#!/usr/bin/env sh

c=$(echo -e "\uf023 Lock\n\uf08b Logout\n\uf9b1 Suspend\n\uf01e Reboot\n\uf011 Shutdown" | rofi \
  -dmenu -i -no-custom -p '>' -lines 6 -width 20 -format s | awk '{print $2}')
echo $c

case $c in
  Lock)
    $HOME/.local/scripts/lock2.sh
  ;;

  Logout)
    i3-msg exit
  ;;

  Suspend)
    systemctl suspend
  ;;

  Hibernate)
    systemctl hibernate
  ;;

  Reboot)
    systemctl reboot
  ;;

  Shutdown)
    systemctl poweroff -i
  ;;

  *) echo "Invalid: $c"; exit 1 ;;
esac
