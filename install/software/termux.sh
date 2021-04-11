#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi "installing, xclip, tree, tmux, zsh, openssh, php, python, git, vim, yarn, nmap, proxychains"
pkg install xclip tree openssh php python yarn nmap proxychains-ng

ppi "Setting zsh as default shell"
chsh -s zsh

ppi "Allow termux access to local storage"
termux-setup-storage

ppi "Symlinking termux config files"
mkdir -p $HOME/.termux
ln -s $HOME/.dotfiles/termux/colors.properties $HOME/.termux/colors.properties
ln -s $HOME/.dotfiles/termux/termux.properties $HOME/.termux/termux.properties
