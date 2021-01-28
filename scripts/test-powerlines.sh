#!/usr/bin/env bash

# Hacked from: https://github.com/ryanoasis/nerd-fonts/tree/master/bin/scripts

text1='Testing'
text2='Nerd Fonts'

leftSymbolsCodes=('E0B0' 'E0B4' 'E0B8' 'E0BC' 'E0C0' 'E0C4' 'E0C6' 'E0C8' 'E0CC' 'E0CE' 'E0CF' 'E0CF' 'E0D1' 'E0D2')
rightSymbolsCodes=('E0B2' 'E0B6' 'E0BA' 'E0BE' 'E0C2' 'E0C5' 'E0C7' 'E0C8' 'E0CC' 'E0CE' 'E0CF' 'E0CF' 'E0D1' 'E0D4')

# shellcheck disable=SC2034
# don't check unused vars we might want to use them later on
colorBgLightBlue='\033[104m' # light blue, bright green is 102
colorBgBlack='\033[40m'
colorBg1='\033[100m'
colorBg2=$colorBgBlack

# shellcheck disable=SC2034
# don't check unused vars we might want to use them later on
colorFgLightBlue='\033[94m'
colorFgLightGray='\033[90m'

# shellcheck disable=SC2034
# don't check unused vars we might want to use them later on
colorFgLightYellow='\033[93m'
colorFgBlack='\033[30m'
colorFg1=$colorFgBlack
colorFg2=$colorFgLightGray
colorBgDefault='\033[49m'

echo -e '\nNerd Fonts :: Testing Powerline Symbol size and alignment\n'

for i in "${!leftSymbolsCodes[@]}"; do
	symbol="\\u${leftSymbolsCodes[$i]}"
	symbol2="\\u${rightSymbolsCodes[$i]}"
	code="${leftSymbolsCodes[$i]}"
	code2="${rightSymbolsCodes[$i]}"

	if [ "$code" = "$code2" ]; then
		symbol2="\\u${rightSymbolsCodes[0]}"
		code2='None'
	fi

	echo -e "$colorBg1$colorFg1$text1 $code $colorFg2$colorBg2$symbol $text2 $colorFg1$colorBgDefault$symbol -- $colorFg1$colorBgDefault$symbol2$colorFg2$colorBg2 $text2 $symbol2$colorBg1$colorFg1 $code2 \e[0m\e[49m"
done

echo ''
