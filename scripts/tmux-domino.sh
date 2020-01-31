#!/bin/bash

## Setup dev environment for Domino Education ##
if ! tmux has-session -t domino; then
    # If not session called domino create a window called DominoFrontend
    # in the frontend folder.
    tmux new -s domino -d -n DominoFrontend -c ~/code/domino/domino-api

    # Split window for main API development
    tmux split-window -t domino:1 -v -p 20 -c ~/code/domino/domino-frontend

    # Split window for watching CSS changes.
    tmux split-window -t domino:1.2 -h -p 66 -c ~/code/domino/domino-frontend

    # Split window for Git.
    tmux split-window -t domino:1.3 -h -p 50 -c ~/code/domino/domino-frontend

    # Install any missing packages and start a server on port 3000.
    tmux send-keys -t domino:1.3 'yr && PORT=3000 yrs' Enter

    # Watch CSS file for changes.
    tmux send-keys -t domino:1.4 'yr css' Enter

    # Run Git status.
    tmux send-keys -t domino:1.2 'gs' Enter

    # Start Homestead server.
    tmux send-keys -t domino:1.1 'hs up' Enter


    # Create a new window called DominoAdmin
    tmux new-window -t domino:2 -n DominoAdmin -c ~/code/domino/domino-api

    # Split window for admin
    tmux split-window -t domino:2 -v -p 20 -c ~/code/domino/domino-admin

    # Split window for watching CSS changes.
    tmux split-window -t domino:2.2 -h -p 66 -c ~/code/domino/domino-admin

    tmux split-window -t domino:2.3 -h -p 50 -c ~/code/domino/domino-admin

    # Install any missing packages and start a server on port 3001.
    tmux send-keys -t domino:2.3 'yr && PORT=3001 yrs' Enter

    # Watch CSS file for changes.
    tmux send-keys -t domino:2.4 'yr css' Enter

    # Get current git status.
    tmux send-keys -t domino:2.2 'gs' Enter

    # Set active pane to main API pane on both wincows.
    tmux select-pane -t domino:1.1
    tmux select-pane -t domino:2.1

    # Select DominoFrontend as main window.
    tmux select-window -t domino:1
fi

# Attach to domino session.
tmux a -t domino
