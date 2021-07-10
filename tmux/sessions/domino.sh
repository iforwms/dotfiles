#!/bin/bash

## Setup dev environment for Domino Education ##
if ! tmux has-session -t domino; then
    tmux new -s domino -d -n api -c ~/code/domino/domino-api

    # API
    tmux split-window -t domino:1 -h -p 20 -c ~/code/domino/domino-api
    tmux send-keys -t domino:1.2 'hs up' Enter

    # React Admin Site
    tmux new-window -t domino -n admin -c ~/code/domino/domino-admin
    tmux split-window -t domino:2 -h -p 25 -c ~/code/domino/domino-admin
    tmux send-keys -t domino:2.2 'yr && PORT=3001 yrs' Enter
    tmux split-window -t domino:2.2 -v -p 50 -c ~/code/domino/domino-admin
    tmux send-keys -t domino:2.3 'yr css' Enter

    # React Study Site
    tmux new-window -t domino -n study -c ~/code/domino/domino-frontend
    tmux split-window -t domino:3 -h -p 25 -c ~/code/domino/domino-frontend
    tmux send-keys -t domino:3.2 'yr && PORT=3000 yrs' Enter
    tmux split-window -t domino:3.2 -v -p 50 -c ~/code/domino/domino-frontend
    tmux send-keys -t domino:3.3 'yr css' Enter

    # SSH Session
    tmux new-window -t domino -n server
    tmux send-keys -t domino:4.1 'ssh dc' Enter

    # Logs
    tmux new-window -t domino -n logs
    tmux send-keys -t domino:5.1 'llog' Enter

    tmux select-pane -t domino:3.1
    tmux select-pane -t domino:2.1
    tmux select-pane -t domino:1.1
fi
