#!/usr/bin/env sh

c=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i \
  -only-match -p '>' -lines 7 -width 20 -format s)
echo $c

case $c in
  Lock)
    $HOME/.local/scripts/lock.sh
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
esac
