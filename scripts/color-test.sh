#!/usr/bin/env sh

ansi_colors () {
  local attr
  for attr in 0 1 2 3 4 5 7; do
      # echo ' -------------------------------------------------------'
      printf "\n ESC[%s;fgcolor;bgcolor ::\n\n" $attr
      local fg
      for fg in 30 31 32 33 34 35 36 37 39; do
          local bg
          for bg in 40 41 42 43 44 45 46 47; do
              printf '\033[%s;%s;%sm %02s;%02s \033[0m' $attr $fg $bg $fg $bg
          done
          printf '\n'
      done
  done
  printf '\n'
}

ansi_colors
