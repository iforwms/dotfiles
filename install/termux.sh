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
