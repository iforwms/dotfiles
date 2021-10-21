#!/bin/bash

## Setup dev environment for Indier Outdoor ##
if ! tmux has-session -t indier; then
    tmux new -s indier -d -n api -c ~/code/indier/indier-api

    # API
    tmux split-window -t indier:1 -h -p 20 -c ~/code/indier/indier-api
    tmux send-keys -t indier:1.2 'hs up' Enter

    # React Site
    tmux new-window -t indier -n react -c ~/code/indier/indier-frontend
    tmux split-window -t indier:2 -h -p 25 -c ~/code/indier/indier-frontend
    tmux send-keys -t indier:2.2 'yr && PORT=4001 yrs' Enter
    tmux split-window -t indier:2.2 -v -p 50 -c ~/code/indier/indier-frontend
    tmux send-keys -t indier:2.3 'yr css' Enter

    # SSH Session
    tmux new-window -t indier -n server
    tmux send-keys -t indier:3.1 'ssh iis' Enter

    tmux select-pane -t indier:2.1
    tmux select-pane -t indier:1.1
fi
