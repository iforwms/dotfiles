#!/bin/bash

## Setup dev environment for Exped Outdoor ##
if ! tmux has-session -t exped; then
    tmux new -s exped -d -n vim -c ~/code/expednet
fi
