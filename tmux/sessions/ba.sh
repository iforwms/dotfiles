#!/bin/bash

## Setup dev environment for Bike Asia ##
if ! tmux has-session -t bike-asia; then
    tmux new -s bike-asia -d -n vim -c ~/code/bike-asia

    # API
    tmux split-window -t bike-asia:1 -h -p 20 -c ~/code/bike-asia
    tmux send-keys -t bike-asia:1.2 'hs up' Enter

    # Logs
    tmux new-window -t bike-asia -n logs
    tmux send-keys -t bike-asia:2.1 'llog' Enter

    # SSH Session
    tmux new-window -t bike-asia -n server
    tmux send-keys -t bike-asia:3.1 'ssh clients' Enter

    tmux select-pane -t bike-asia:3.1
    tmux select-pane -t bike-asia:2.1
    tmux select-pane -t bike-asia:1.1
fi
