#!/usr/bin/env bash
#
# Must define INTERN_SCREEN and EXTERN_SCREEN
#

c=$(echo -e "Extern\nIntern\nMirror\nExtern -> Intern\nIntern -> Extern" | rofi \
  -font 'JetBrainsMono NerdFont 16' -dmenu -i -no-custom -p '>' -lines 5 -format s)
echo $c ...

#while [[ "$#" -gt 0 ]]; do
#	case $1 in
#		-e|--extern) option="extern"; break ;;
#		-i|--intern) option="intern"; break ;;
#		-m|--mirror) option="mirror"; break ;;
#		--pe) option="pe"; break ;;
#		--pi) option="pi"; break ;;
#		--ei) option="ei"; break ;;
#		--ie) option="ie"; break ;;
#		*) echo "Unknown parameter: $1"; exit 1 ;;
#	esac
#	shift
#done

case $c in

	"Extern")
		echo "Monitor extern only"
		xrandr --output "$INTERN_SCREEN" --off --output "$EXTERN_SCREEN" --auto
		bspc monitor -d 1 2 3 4 5 6 7 8 9
	;;

	"Intern")
		echo "Monitor intern only"
		xrandr --output "$EXTERN_SCREEN" --off --output "$INTERN_SCREEN" --auto
		bspc monitor -d 1 2 3 4 5 6 7 8 9
	;;

	"Mirror")
		echo "Monitor start mirror"
		xrandr --output "$INTERN_SCREEN" --auto --output "$EXTERN_SCREEN" --auto --same-as "$INTERN_SCREEN"
		bspc monitor -d 1 2 3 4 5 6 7 8 9
	;;

	"Extern -> Intern")
		if xrandr -q | grep "$EXTERN_SCREEN connected"; then
			echo "Monitor extern-intern"
			xrandr --output "$EXTERN_SCREEN" --auto --left-of "$INTERN_SCREEN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	"Intern -> Extern")
		if xrandr -q | grep "$EXTERN_SCREEN connected"; then
			echo "Monitor intern-extern"
			xrandr --output "$INTERN_SCREEN" --auto --left-of "$EXTERN_SCREEN" --auto
		else
			echo "Extern monitor is disconnected"
		fi
	;;

	*) echo "Invalid option: $c"; exit 1 ;;

esac
