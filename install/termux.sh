#!/bin/bash

# Termux setup
echo "Updating packages"
pkg upgrade

echo "installing, tree, tmux, zsh, openssh, php, python, git, vim, yarn, nmap, proxychains"
pkg install tree tmux openssh zsh php python vim git yarn nmap proxychains-ng

echo "Setting zsh as default shell"
chsh -s zsh

echo "Allow termux access to local storage"
termux-setup-storage

echo "Symlink .gitconfig file to the home directory"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

echo "Symlinking termux config files"
mkdir -p $HOME/.termux
ln -s $HOME/.dotfiles/termux/colors.properties $HOME/.termux/colors.properties
ln -s $HOME/.dotfiles/termux/termux.properties $HOME/.termux/termux.properties
