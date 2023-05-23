#!/bin/bash

killall polybar
pkill polybar

while pgrep -x polybar > /dev/null; do sleep 1; done

#if [ -z "$(pgrep -x polybar)" ]; then
#  for m in $(polybar --list-monitors | cut -d":" -f1); do
#    MONITOR=$m polybar --reload default &
#  done
#fi

if xrandr -q | grep "^$EXTERN_SCREEN connected"; then
  MONITOR=$INTERN_SCREEN polybar default 2>&1 | tee -a /tmp/polybar1.log & disown
  MONITOR=$EXTERN_SCREEN polybar default 2>&1 | tee -a /tmp/polybar2.log & disown
else
  MONITOR=$INTERN_SCREEN polybar default 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Polybar launched..."

