#!/bin/bash

## Setup dev environment for Exped Outdoor ##
if ! tmux has-session -t exped; then
    tmux new -s exped -d -n vim -c ~/code/expednet

    tmux new-window -t exped -n server
    tmux send-keys -t exped:2.1 'ssh exped' Enter

    tmux select-pane -t exped:1.1
fi
