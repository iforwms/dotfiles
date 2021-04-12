#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install nmap
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install nmap
else
  ppi "Installing using apt"
  sudo apt install -y nmap
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .nmap"
# rm -rf $HOME/.nmap
# ln -s $HOME/.dotfiles/.nmap $HOME/.nmap
