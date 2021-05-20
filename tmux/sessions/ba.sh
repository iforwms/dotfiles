#!/bin/bash

## Setup dev environment for Bike Asia ##
if ! tmux has-session -t bike-asia; then
    tmux new -s bike-asia -d -n vim -c ~/code/bike-asia
fi
