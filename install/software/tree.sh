#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install tree
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install tree
else
  ppi "Installing using apt"
  sudo apt install tree
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .tree"
# rm -rf $HOME/.tree
# ln -s $HOME/.dotfiles/.tree $HOME/.tree
