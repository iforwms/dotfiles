#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install yarn
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install yarn
else
  ppi "Installing using apt"
  sudo apt install yarn
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .yarn"
# rm -rf $HOME/.yarn
# ln -s $HOME/.dotfiles/.yarn $HOME/.yarn
