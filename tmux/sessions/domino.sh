#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

## Setup dev environment for Domino Education ##
if ! tmux has-session -t domino; then
    tmux new -s domino -d -n api -c ~/code/domino/domino-api

    tmux split-window -t domino:1 -v -p 20 -c ~/code/domino/domino-api

    tmux new-window -t domino -n study ~/code/domino/domino-frontend
    tmux split-window -t domino:1.2 -h -p 66 -c ~/code/domino/domino-api
    tmux send-keys -t domino:1.3 'yr && PORT=3001 yrs' Enter

#     # Watch CSS file for changes.
#     tmux send-keys -t domino:1.4 'yr css' Enter

#     # Run Git status.
#     tmux send-keys -t domino:1.2 'gs' Enter

#     # Start Homestead server.
#     tmux send-keys -t domino:1.1 'hs up' Enter

#     # Set active pane to main API pane on both wincows.
#     tmux select-pane -t domino:1.1
fi

# Attach to domino session.
ppi "Domino session ready."
