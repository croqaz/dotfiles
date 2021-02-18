#!/usr/bin/env bash
#
# Script from https://github.com/regolith-linux/regolith-i3xrocks-config
# Adapted from https://github.com/hastinbe/i3blocks-battery-plus

# Colors
_COLOR_00=${_COLOR_00:-"#9D0006"}
_COLOR_30=${_COLOR_30:-"#AF3A03"}
_COLOR_60=${_COLOR_60:-"#B57614"}

# Symbols
_SYMBOL_UNKNOWN=${_SYMBOL_UNKNOWN:-"&#xf128;"}
_SYMBOL_BATT_100=${_SYMBOL_BATT_100:-"&#xf240;"}
_SYMBOL_BATT_90=${_SYMBOL_BATT_90:-"&#xf241;"}
_SYMBOL_BATT_60=${_SYMBOL_BATT_60:-"&#xf242;"}
_SYMBOL_BATT_30=${_SYMBOL_BATT_30:-"&#xf243;"}
_SYMBOL_BATT_00=${_SYMBOL_BATT_00:-"&#xf244;"}
_SYMBOL_DIRECTION_UP=${_SYMBOL_DIRECTION_UP:-"&#8593;"}
_SYMBOL_DIRECTION_DOWN=${_SYMBOL_DIRECTION_DOWN:-"&#8595;"}

BUTTON=${button:-}

# Get battery status.
#
# Returns:
#   The battery's status or state.
get_battery_status() {
    echo "$__UPOWER_INFO" | awk -W posix '$1 == "state:" {print $2}'
}

# Get battery percentage.
#
# Returns:
#   The battery's percentage, without the %.
get_battery_percent() {
    echo "$__UPOWER_INFO" | awk -W posix '$1 == "percentage:" { gsub("%","",$2); print int($2) }'
}

BATT_DEVICE="DisplayDevice"
__UPOWER_INFO=$(upower --show-info "/org/freedesktop/UPower/devices/battery_${BLOCK_INSTANCE:-BAT0}")

BATT_PERCENT=$(get_battery_percent)
CHARGE_STATE=$(get_battery_status)

if [ -z "$BATT_PERCENT" ]; then
    exit 0
elif [ "$BATT_PERCENT" -ge 0 ] && [ "$BATT_PERCENT" -le 20 ]; then
    LABEL_ICON=$_SYMBOL_BATT_00
    VALUE_COLOR=$_COLOR_00
elif [ "$BATT_PERCENT" -ge 20 ] && [ "$BATT_PERCENT" -le 50 ]; then
    LABEL_ICON=$_SYMBOL_BATT_30
    VALUE_COLOR=$_COLOR_30
elif [ "$BATT_PERCENT" -ge 50 ] && [ "$BATT_PERCENT" -le 80 ]; then
    LABEL_ICON=$_SYMBOL_BATT_60
    VALUE_COLOR=$_COLOR_60
elif [ "$BATT_PERCENT" -ge 80 ] && [ "$BATT_PERCENT" -le 95 ]; then
    LABEL_ICON=$_SYMBOL_BATT_90
else
    LABEL_ICON=$_SYMBOL_BATT_100
fi

if [ -z "$CHARGE_STATE" ]; then
    exit 0
elif [ "$CHARGE_STATE" == "discharging" ]; then
    CHARGE_ICON=$_SYMBOL_DIRECTION_DOWN
elif [ "$CHARGE_STATE" == "charging" ]; then
    CHARGE_ICON=$_SYMBOL_DIRECTION_UP
elif [ "$CHARGE_STATE" == "fully-charged" ]; then
    CHARGE_ICON=""
else
    CHARGE_ICON=$_SYMBOL_UNKNOWN
fi

_SPACE="  "

if [ -n "$VALUE_COLOR" ]; then
	ICON_SPAN="<span color=\"${VALUE_COLOR}\">$LABEL_ICON"
else
	ICON_SPAN="<span>$LABEL_ICON"
fi

if [ "$BATT_PERCENT" == 100 ]; then
	echo "${ICON_SPAN}${_SPACE}${BATT_PERCENT}%</span>"
else
	echo "${ICON_SPAN}${_SPACE}${BATT_PERCENT}% ${CHARGE_ICON}</span>"
fi

# Handle click events
# if [[ "x${BUTTON}" == "x1" ]]; then
# fi
