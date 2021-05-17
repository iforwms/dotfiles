#!/bin/bash

## Setup dev environment ##
if ! tmux has-session -t dev; then
    # If not session called dev create a window called cmus
    tmux new -s dev -d -n cmus

    # Start music player.
    tmux send-keys -t dev:1.1 'cmus' Enter

    # Create a new window for API
    tmux new-window -t dev:2 -n API -c ~/code/domino/domino-api

    # Split window for git status
    tmux split-window -t dev:2 -h -p 30 -c ~/code/domino/domino-frontend

    # Start Homestead server.
    tmux send-keys -t dev:2.2 'hs up' Enter

    # Run Git status.
    tmux send-keys -t dev:2.1 'ggp && ggs && ctags -R' Enter

    # Create a new window for frontend
    tmux new-window -t dev:3 -n Frontend -c ~/code/domino/domino-frontend

    # Split window for main development
    tmux split-window -t dev:3 -h -p 30 -c ~/code/domino/domino-frontend

    # Split window for watching CSS changes.
    # tmux split-window -t dev:2.2 -h -p 66 -c ~/code/domino/domino-frontend

    # Split window for Git.
    # tmux split-window -t dev:2.3 -h -p 50 -c ~/code/domino/domino-frontend

    # Install any missing packages and start a server on port 3000.
    tmux send-keys -t dev:3.2 'ctags -R && yr && PORT=3000 yrs' Enter

    # Watch CSS file for changes.
    # tmux send-keys -t dev:2.4 'yr css' Enter

    # Run Git status.
    tmux send-keys -t dev:3.1 'gs' Enter

    # Create a new window called Admin
    tmux new-window -t dev:4 -n Admin -c ~/code/domino/domino-admin

    # Split window for admin
    tmux split-window -t dev:4 -h -p 30 -c ~/code/domino/domino-admin

    # Split window for watching CSS changes.
    # tmux split-window -t dev:3.2 -h -p 66 -c ~/code/domino/domino-admin

    # tmux split-window -t dev:3.3 -h -p 50 -c ~/code/domino/domino-admin

    # Install any missing packages and start a server on port 3001.
    tmux send-keys -t dev:4.2 'ctags -R && yr && PORT=3001 yrs' Enter

    # Watch CSS file for changes.
    # tmux send-keys -t dev:3.4 'yr css' Enter

    # Get current git status.
    tmux send-keys -t dev:4.1 'gs' Enter

    # Create a new window for SSH
    tmux new-window -t dev:5 -n DC

    # Get current git status.
    tmux send-keys -t dev:5.1 'ssh dc' Enter

    # Create a new window for UI Library
    tmux new-window -t dev:6 -n UILib -c ~/code/personal/react-components

    # Create split pane for UI Library
    tmux split-window -t dev:6 -h -p 30 -c ~/code/personal/react-components

    # Start build process
    tmux send-keys -t dev:6.2 'ctags -R && yr build-watch' Enter

    # Create a new window for Chordy
    tmux new-window -t dev:7 -n chordy -c ~/code/personal/chordie

    # Create a new window for VPN
    tmux new-window -t dev:8 -n vpn -c ~

    # Connect to VPN
    tmux send-keys -t dev:8.1 'lon' Enter

    # Set active pane to main API pane on both windows.
    tmux select-pane -t dev:2.1
    tmux select-pane -t dev:3.1
    tmux select-pane -t dev:4.1
    tmux select-pane -t dev:6.1

    # Select API as main window.
    tmux select-window -t dev:2
fi
