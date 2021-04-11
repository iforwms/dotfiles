#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install nginx
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install nginx
else
  ppi "Installing using apt"
  sudo apt install nginx
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .nginx"
# rm -rf $HOME/.nginx
# ln -s $HOME/.dotfiles/.nginx $HOME/.nginx
