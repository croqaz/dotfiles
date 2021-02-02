#!/usr/bin/env sh
free -m | sed -n '2{p;q}' | awk '{printf "M=%.4d\n", $3}'
