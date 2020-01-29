#!/bin/bash

# To bind, type the following command in cmus
# :bind -f common u shell ~/.dotfiles/tmux/update-cmus-library.sh
cmus-remote -C clear
cmus-remote -C "add $HOME/Music/local"
cmus-remote -C "update-cache -f"
