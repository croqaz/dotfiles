#!/usr/bin/env sh
free -m | sed -n '2{p;q}' | awk '{printf "<span size=\"large\" rise=\"1000\">&#8863;</span>&#8202;<span font_family=\"Hack\" rise=\"2000\">%.4d</span>\n", $3}'
