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
  sudo apt install -y tree
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .tree"
# rm -rf $HOME/.tree
# ln -s $HOME/.dotfiles/.tree $HOME/.tree
