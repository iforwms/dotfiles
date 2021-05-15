#!/bin/bash

## Setup dev environment for Domino Education ##
if ! tmux has-session -t domino; then
    # If not session called domino create a window called react
    # in the frontend folder.
    tmux new -s domino -d -n react -c ~/code/domino/domino-api

    # Split window for main API development
    tmux split-window -t domino:1 -v -p 20 -c ~/code/domino/domino-frontend

    # Split window for watching CSS changes.
    tmux split-window -t domino:1.2 -h -p 66 -c ~/code/domino/domino-frontend

    # Split window for Git.
    tmux split-window -t domino:1.3 -h -p 50 -c ~/code/domino/domino-frontend

    # Install any missing packages and start a server on port 3000.
    tmux send-keys -t domino:1.3 'yr && PORT=3002 yrs' Enter

    # Watch CSS file for changes.
    tmux send-keys -t domino:1.4 'yr css' Enter

    # Run Git status.
    tmux send-keys -t domino:1.2 'gs' Enter

    # Start Homestead server.
    tmux send-keys -t domino:1.1 'hs up' Enter

    # Set active pane to main API pane on both wincows.
    tmux select-pane -t domino:1.1
fi

# Attach to domino session.
tmux a -t domino
