#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install python
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install python
else
  ppi "Installing using apt"
  sudo apt install python
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .python"
# rm -rf $HOME/.python
# ln -s $HOME/.dotfiles/.python $HOME/.python
