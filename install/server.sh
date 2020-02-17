#!/bin/bash

sudo -v

echo "Setting up server..."

echo "Updating repositories"
sudo apt update

echo "Upgrading packages"
sudo apt upgrade -y

# TODO
# Install Yarn, Node, Composer

echo "Installing ZSH, tmux"
sudo apt install -y zsh tmux

echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
