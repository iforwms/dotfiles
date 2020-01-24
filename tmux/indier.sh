#!/bin/bash

## Setup dev environment for Indier Outdoor ##
if ! tmux has-session -t indier; then
    # If not session called indier create a window called IndierFrontend
    # in the frontend folder.
    tmux new -s indier -d -n IndierFrontend -c ~/code/indier/indier-frontend

    # Split window for main API development
    tmux split-window -t indier:1 -v -p 80 -c ~/code/indier/indier-api

    # Split window for watching CSS changes.
    tmux split-window -t indier:1.1 -h -p 50 -c ~/code/indier/indier-frontend

    # Install any missing packages and start a server on port 3000.
    tmux send-keys -t indier:1.1 'yr && PORT=3002 yrs' Enter

    # Watch CSS file for changes.
    tmux send-keys -t indier:1.2 'yr css' Enter

    # Start Homestead server.
    tmux send-keys -t indier:1.3 'hs up' Enter

    # Set active pane to main API pane on both wincows.
    tmux select-pane -t indier:1.3
fi

# Attach to indier session.
tmux a -t indier
