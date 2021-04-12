#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install imagemagick
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install imagemagick
else
  ppi "Installing using apt"
  sudo apt install imagemagick
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .imagemagick"
# rm -rf $HOME/.imagemagick
# ln -s $HOME/.dotfiles/.imagemagick $HOME/.imagemagick
