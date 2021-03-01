#!/usr/bin/env bash
#
# Must define INTERN_SCREEN and EXTERN_SCREEN
#

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
		if xrandr -q | grep "$EXTERN_SCREEN disconnected"; then
			echo "Extern monitor is disconnected, using intern"
			xrandr --output "$EXTERN_SCREEN" --off --output "$INTERN_SCREEN" --auto
		else
			echo "Monitor extern only"
			xrandr --output "$INTERN_SCREEN" --off --output "$EXTERN_SCREEN" --auto
		fi
    ;;

	"intern")
		echo "Monitor intern only"
		xrandr --output "$EXTERN_SCREEN" --off --output "$INTERN_SCREEN" --auto
	;;

	"mirror")
		echo "Monitor start mirror"
		xrandr --output "$INTERN_SCREEN" --auto --output "$EXTERN_SCREEN" --auto --same-as "$INTERN_SCREEN"
	;;

	"pe")
		if xrandr -q | grep "$EXTERN_SCREEN disconnected"; then
			echo "Extern monitor is disconnected"
		else
			echo "Monitor primary extern"
			xxrandr --output "$EXTERN_SCREEN" --primary
		fi
	;;

	"pi")
		echo "Monitor primary intern"
		xrandr --output "$INTERN_SCREEN" --primary
	;;

	"ei")
		if xrandr -q | grep "$EXTERN_SCREEN connected"; then
			echo "Monitor extern-intern"
			xrandr --output "$EXTERN_SCREEN" --auto --left-of "$INTERN_SCREEN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	"ie")
		if xrandr -q | grep "$EXTERN_SCREEN connected"; then
			echo "Monitor intern-extern"
			xrandr --output "$INTERN_SCREEN" --auto --left-of "$EXTERN_SCREEN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	*) echo "Option not implemented: $option"; exit 1 ;;

esac
