#!/usr/bin/env bash

INTERN=eDP-1
EXTERN=DP-1

while [[ "$#" -gt 0 ]]; do
	case $1 in
		-e|--extern) option="extern"; break ;;
		-i|--intern) option="intern"; break ;;
		-m|--mirror) option="mirror"; break ;;
		--pe) option="pe"; break ;;
		--pi) option="pi"; break ;;
		--ei) option="ei"; break ;;
		--ie) option="ie"; break ;;
		*) echo "Unknown parameter: $1"; exit 1 ;;
	esac
	shift
done

case $option in

	"extern")
		if xrandr -q | grep "$EXTERN disconnected"; then
			echo "Extern monitor is disconnected, using intern"
			xrandr --output "$EXTERN" --off --output "$INTERN" --auto
		else
			echo "Monitor extern only"
			xrandr --output "$INTERN" --off --output "$EXTERN" --auto
		fi
    ;;

	"intern")
		echo "Monitor intern only"
		xrandr --output "$EXTERN" --off --output "$INTERN" --auto
	;;

	"mirror")
		echo "Monitor start mirror"
		xrandr --output "$INTERN" --auto --output "$EXTERN" --auto --same-as "$INTERN"
	;;

	"pe")
		if xrandr -q | grep "$EXTERN disconnected"; then
			echo "Extern monitor is disconnected"
		else
			echo "Monitor primary extern"
			xxrandr --output "$EXTERN" --primary
		fi
	;;

	"pi")
		echo "Monitor primary intern"
		xrandr --output "$INTERN" --primary
	;;

	"ei")
		if xrandr -q | grep "$EXTERN connected"; then
			echo "Monitor extern-intern"
			xrandr --output "$EXTERN" --auto --left-of "$INTERN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	"ie")
		if xrandr -q | grep "$EXTERN connected"; then
			echo "Monitor intern-extern"
			xrandr --output "$INTERN" --auto --left-of "$EXTERN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	*) echo "Option not implemented: $option"; exit 1 ;;

esac
