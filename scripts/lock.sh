#!/usr/bin/env bash

B='#00000000'  # blank
C='#ffffffFF'  # clear ish
D='#0A7ACAFF'  # default
T='#569cd6FF'  # text
W='#F44747FF'  # wrong
V='#FFAF00FF'  # verifying
VT='#608B4EFF'
BW='#1E1E1EFF'

i3lock \
--radius 75 \
--indpos="w/2:h/2" \
--timepos="w/2:h/2-200" \
--datepos="w/2:h/2-160" \
--greeterpos="w/2:h/2" \
--insidevercolor=$B   \
--ringvercolor=$V     \
--ring-width=6 \
\
--insidewrongcolor=$W \
--ringwrongcolor=$C   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$VT      \
--wrongcolor=$C       \
--timecolor=$C        \
--datecolor=$C        \
--layoutcolor=$T      \
--keyhlcolor=$VT      \
--bshlcolor=$W        \
\
--screen 1            \
--blur 15             \
--clock               \
--indicator           \
--timestr="%I:%M:%S %p"  \
--datestr="%A %d %b"     \
--wrongtext="incorrect!" \
--veriftext="verifying"  \
--timesize=75  \
--datesize=30  \
--verifsize=20 \
--wrongsize=20
