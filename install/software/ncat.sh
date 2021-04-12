#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install ncat
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install ncat
else
  ppi "Installing using apt"
  sudo apt install ncat
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .ncat"
# rm -rf $HOME/.ncat
# ln -s $HOME/.dotfiles/.ncat $HOME/.ncat
