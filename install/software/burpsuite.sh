#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install burpsuite
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install burpsuite
else
  ppi "Installing using apt-get"
  sudo apt-get install -y burpsuite
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .burpsuite"
# rm -rf $HOME/.burpsuite
# ln -s $HOME/.dotfiles/.burpsuite $HOME/.burpsuite
