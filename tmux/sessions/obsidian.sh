#!/bin/bash

## Setup dev environment for Obsidian notes ##
if ! tmux has-session -t obsidian; then
    tmux new -s obsidian -d -n vim -c ~/obsidian
fi

