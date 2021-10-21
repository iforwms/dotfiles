#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install ncat
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install ncat
else
  ppi "Installing using apt-get"
  sudo apt-get install -y ncat
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .ncat"
# rm -rf $HOME/.ncat
# ln -s $HOME/.dotfiles/.ncat $HOME/.ncat
