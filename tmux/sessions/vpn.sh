#!/bin/bash

## TODO: Make sure OS is MacOs

## Connect to VPN##
if ! tmux has-session -t vpn; then
    # If not session called vpn create a window called vpn
    tmux new -s vpn -d -n vpn -c ~/code

    tmux send-keys -t vpn:1.1 'lon' Enter
fi

# Attach to vpn session.
tmux a -t vpn
