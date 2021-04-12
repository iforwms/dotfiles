#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install node
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install node
else
  ppi "Installing using apt"
  sudo apt install node
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .node"
# rm -rf $HOME/.node
# ln -s $HOME/.dotfiles/.node $HOME/.node
