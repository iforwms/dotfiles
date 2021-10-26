#!/bin/bash

[ "$TERM" = "unknown" ] && TERM='' # use default
term=${TERM:-xterm-<t_CO>color} # use xterm as default if no terminal set

# Helper
_color_text() {
    if [ -z "$1" ] && [ ! -t 0 ]; then
        # no terminal so use STDIN pipe
        cat </dev/stdin
        tput -T"$term" sgr0;
    elif [ -n "$1" ] && [ ! "$1" = "+" ]; then
        # use given text
        echo -n "$@"
        tput -T"$term" sgr0;
    fi
    # else only keep it open
}

# Foreground color
black() { tput -T"$term" setaf 0; _color_text "$@"; }
red() { tput -T"$term" setaf 1; _color_text "$@"; }
green() { tput -T"$term" setaf 2; _color_text "$@"; }
yellow() { tput -T"$term" setaf 3; _color_text "$@"; }
blue() { tput -T"$term" setaf 4; _color_text "$@"; }
magenta() { tput -T"$term" setaf 5; _color_text "$@"; }
cyan() { tput -T"$term" setaf 6; _color_text "$@"; }
white() { tput -T"$term" setaf 7; _color_text "$@"; }

# Background color
bg_black() { tput -T"$term" setab 0; _color_text "$@"; }
bg_red() { tput -T"$term" setab 1; _color_text "$@"; }
bg_green() { tput -T"$term" setab 2; _color_text "$@"; }
bg_yellow() { tput -T"$term" setab 3; _color_text "$@"; }
bg_blue() { tput -T"$term" setab 4; _color_text "$@"; }
bg_magenta() { tput -T"$term" setab 5; _color_text "$@"; }
bg_cyan() { tput -T"$term" setab 6; _color_text "$@"; }
bg_white() { tput -T"$term" setab 7; _color_text "$@"; }

# Styles
bold() { tput -T"$term" bold; _color_text "$@"; }
underline() { tput -T"$term" smul; _color_text "$@"; }
inverse() { tput -T"$term" rev; _color_text "$@"; }
dim() { tput -T"$term" dim; _color_text "$@"; }

# Reset
reset() { tput -T"$term" sgr0; }

decolor() {
  if [ -z "$1" ] && [ ! -t 0 ]; then
    # no parameters but STDIN pipe is given
    sed 's/\x1B\[[0-9;]*[a-zA-Z]//g;s/\x1B\x28\x42//g' </dev/stdin
  else
    # use parameters
    sed 's/\x1B\[[0-9;]*[a-zA-Z]//g;s/\x1B\x28\x42//g' <<< "$@"
    # use hexdump -C ore cat -A to debug output
  fi
}

