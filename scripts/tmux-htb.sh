#!/bin/bash

if [[ ! $1 ]]
then
    echo 'Usage: ./tmux-htb.sh [box name]'

    echo
    echo "Available boxes:"
    echo $(find $HOME/htb -maxdepth 1 -type d ! -name '.git'|awk -F/ 'BEGIN{ORS=" "} NR!=1 {print $NF}')
    echo

    exit 1
else
    DIR=$HOME/htb/$1

    echo "Updating repo…"
    git -C $HOME/htb pull

    echo "Setting up $1"
    mkdir -p $DIR/{nmap,gobuster,www}
    touch $DIR/notes.md
fi

## Setup dev environment ##
if ! tmux has-session -t htb; then
    # If not session called htb create a window called openvpn
    tmux new -s htb -d -n openvpn

    # Start openvpn.
    tmux send-keys -t htb:1.1 "openvpn $HOME/htb/iforwms.ovpn" Enter

    # Create a new window for notes
    tmux new-window -t htb:2 -n notes -c $DIR

    # Open notes in vi
    tmux send-keys -t htb:2.1 'vi notes.md' Enter

    # Create a new window for nmap
    tmux new-window -t htb:3 -n nmap -c $DIR

    # Start initial nmap scan
    tmux send-keys -t htb:3.1 'nmap -sC -sV -oA nmap/initial'

    # Create a new window called gobuster
    tmux new-window -t htb:4 -n gobuster -c $DIR

    # Set active pane to main API pane on both windows.
    tmux select-pane -t htb:2.1
    tmux select-pane -t htb:3.1
    tmux select-pane -t htb:4.1

    # Select API as main window.
    tmux select-window -t htb:2
fi

# Attach to htb session.
tmux a -t htb
