#!/bin/bash

sudo -v

echo "Setting up server..."

echo "Updating repositories"
sudo apt update

echo "Upgrading packages"
sudo apt upgrade -y

# TODO
# Install Yarn, Node, Composer

echo "Installing ZSH, tmux, xclip"
sudo apt install -y zsh tmux xclip

echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

echo "Installing chafa"
sudo add-apt-repository ppa:hpjansson/chafa
sudo apt install chafa
