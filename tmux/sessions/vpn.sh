#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ ! $(uname -a|grep "Darwin") ]]; then
    ppe "Session must only be started on an iOS device."
    exit 1
fi

## Connect to VPN##
if ! tmux has-session -t vpn; then
    # If not session called vpn create a window called vpn
    tmux new -s vpn -d -n vpn -c $HOME/code

    tmux send-keys -t vpn:1.1 'networksetup -setsocksfirewallproxy "Wi-Fi" localhost 2080 && ssh -D 2080 clients' Enter
fi

# Attach to vpn session.
tmux a -t vpn
