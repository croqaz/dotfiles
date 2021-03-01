#!/usr/bin/env bash

B='#55555555'  # blank
C='#0AAEB3FF'  # clear ish
D='#2C78BFFF'  # default
T='#0AAEB3FF'  # text
W='#FF5F00FF'  # wrong
V='#519F50FF'  # verifying
VT='#608B4EFF'
BW='#1E1E1EFF'

i3lock \
--radius 75 \
--indpos="w/2:h/2" \
--timepos="w/2:h/2-200" \
--datepos="w/2:h/2-120" \
--greeterpos="w/2:h/2" \
--insidevercolor=$B   \
--ringvercolor=$V     \
--ring-width=6        \
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
--blur 24             \
--clock               \
--indicator           \
--timestr="%H:%M"     \
--datestr="%A %d %b"  \
--wrongtext="incorrect!" \
--veriftext="verifying"  \
--timesize=90  \
--datesize=45  \
--verifsize=20 \
--wrongsize=20
