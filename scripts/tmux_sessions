#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ ! $1 ]]; then
    ppw "Session name required, available sessions:"
    find $HOME/.dotfiles/tmux/sessions -type f -name "*.sh" -printf "    - %f\n"|sed "s/.sh$//"|sort
    echo
    exit 1
fi

$HOME/.dotfiles/tmux/sessions/$1.sh

ppi "$1 up and running!"
