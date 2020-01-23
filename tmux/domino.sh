#!/bin/bash

## Setup dev environment for Domino Education ##
if ! tmux has-session -t domino; then
    # Set up frontend panes.
    tmux new -s domino -d -n DominoFrontend -c ~/code/domino/domino-frontend
    tmux split-window -t domino:1 -v -p 80 -c ~/code/domino/domino-api
    tmux split-window -t domino:1.1 -h -p 50 -c ~/code/domino/domino-frontend
    tmux send-keys -t domino:1.1 'yr && PORT=3000 yrs' Enter
    tmux send-keys -t domino:1.2 'yr css' Enter

    # Set up admin panes.
    tmux new-window -t domino:2 -n DominoAdmin -c ~/code/domino/domino-admin
    tmux split-window -t domino:2 -v -p 80 -c ~/code/domino/domino-api
    tmux split-window -t domino:2.1 -h -p 50 -c ~/code/domino/domino-admin
    tmux send-keys -t domino:2.1 'yr && PORT=3001 yrs' Enter
    tmux send-keys -t domino:2.2 'yr css' Enter

    tmux select-pane -t domino:2.3
    tmux select-pane -t domino:1.3
    tmux select-window -t domino:1
fi

tmux a -t domino
