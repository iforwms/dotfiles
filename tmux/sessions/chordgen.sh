#!/bin/bash

## Setup dev environment for Chordgen ##
if ! tmux has-session -t chordgen then
    tmux new -s chordgen -d -n vim -c ~/code/personal/chordgen
fi

