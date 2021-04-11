#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install netcat
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install netcat
else
  ppi "Installing using apt"
  sudo apt install netcat
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .netcat"
# rm -rf $HOME/.netcat
# ln -s $HOME/.dotfiles/.netcat $HOME/.netcat
