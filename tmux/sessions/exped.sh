#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

## Setup dev environment for Exped Outdoor ##
if ! tmux has-session -t exped; then
    tmux new -s exped -d -n vim -c ~/code/expednet
fi

ppi "Exped session created."
