#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install mysql
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install mysql
else
  ppi "Installing using apt"
  sudo apt install mysql
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .mysql"
# rm -rf $HOME/.mysql
# ln -s $HOME/.dotfiles/.mysql $HOME/.mysql
