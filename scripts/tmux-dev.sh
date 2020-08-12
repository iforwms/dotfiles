#!/bin/bash

## Setup dev environment ##
if ! tmux has-session -t alpha; then
    # If not session called alpha create a window called cmus
    tmux new -s alpha -d -n cmus

    # Start music player.
    tmux send-keys -t alpha:1.1 'cmus' Enter

    # Create a new window for API
    tmux new-window -t alpha:2 -n API -c ~/code/domino/domino-api

    # Split window for git status
    tmux split-window -t alpha:2 -h -p 30 -c ~/code/domino/domino-frontend

    # Start Homestead server.
    tmux send-keys -t alpha:2.2 'hs up' Enter

    # Run Git status.
    tmux send-keys -t alpha:2.1 'ggp && ggs' Enter

    # Create a new window for frontend
    tmux new-window -t alpha:3 -n Frontend -c ~/code/domino/domino-frontend

    # Split window for main development
    tmux split-window -t alpha:3 -h -p 30 -c ~/code/domino/domino-frontend

    # Split window for watching CSS changes.
    # tmux split-window -t alpha:2.2 -h -p 66 -c ~/code/domino/domino-frontend

    # Split window for Git.
    # tmux split-window -t alpha:2.3 -h -p 50 -c ~/code/domino/domino-frontend

    # Install any missing packages and start a server on port 3000.
    tmux send-keys -t alpha:3.2 'yr && PORT=3000 yrs' Enter

    # Watch CSS file for changes.
    # tmux send-keys -t alpha:2.4 'yr css' Enter

    # Run Git status.
    tmux send-keys -t alpha:3.1 'gs' Enter

    # Create a new window called Admin
    tmux new-window -t alpha:4 -n Admin -c ~/code/domino/domino-admin

    # Split window for admin
    tmux split-window -t alpha:4 -h -p 30 -c ~/code/domino/domino-admin

    # Split window for watching CSS changes.
    # tmux split-window -t alpha:3.2 -h -p 66 -c ~/code/domino/domino-admin

    # tmux split-window -t alpha:3.3 -h -p 50 -c ~/code/domino/domino-admin

    # Install any missing packages and start a server on port 3001.
    tmux send-keys -t alpha:4.2 'yr && PORT=3001 yrs' Enter

    # Watch CSS file for changes.
    # tmux send-keys -t alpha:3.4 'yr css' Enter

    # Get current git status.
    tmux send-keys -t alpha:4.1 'gs' Enter

    # Create a new window for SSH
    tmux new-window -t alpha:5 -n DC

    # Get current git status.
    tmux send-keys -t alpha:5.1 'ssh dc' Enter

    # Create a new window for UI Library
    tmux new-window -t alpha:6 -n UILib -c ~/code/personal/react-components

    # Create split pane for UI Library
    tmux split-window -t alpha:6 -h -p 30 -c ~/code/personal/react-components

    # Start build process
    tmux send-keys -t alpha:6.2 'yr build-watch' Enter

    # Set active pane to main API pane on both windows.
    tmux select-pane -t alpha:2.1
    tmux select-pane -t alpha:3.1
    tmux select-pane -t alpha:4.1
    tmux select-pane -t alpha:6.1

    # Select API as main window.
    tmux select-window -t alpha:2
fi

# Attach to alpha session.
tmux a -t alpha
