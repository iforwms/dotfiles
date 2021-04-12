#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install xclip
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install xclip
else
  ppi "Installing using apt-get"
  sudo apt-get install -y xclip
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .xclip"
# rm -rf $HOME/.xclip
# ln -s $HOME/.dotfiles/.xclip $HOME/.xclip
