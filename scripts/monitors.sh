#!/usr/bin/env bash

INTERN=eDP1
EXTERN=DP2

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
		echo "Monitor extern only with fallback"
		if xrandr -q | grep "$EXTERN disconnected"; then
			xrandr --output "$EXTERN" --off --output "$INTERN" --auto
		else
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
		echo "Monitor primary extern"
		xrandr --output "$EXTERN" --primary
	;;

	"pi")
		echo "Monitor primary intern"
		xrandr --output "$INTERN" --primary
	;;

	"ei")
		echo "Monitor extern-intern"
		xrandr --output "$EXTERN" --auto --left-of "$INTERN" --auto
	;;

	"ie")
		echo "Monitor intern-extern"
		xrandr --output "$INTERN" --auto --left-of "$EXTERN" --auto
	;;

	*) echo "Option not implemented: $option"; exit 1 ;;

esac
