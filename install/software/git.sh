#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install git
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install git
else
  ppi "Installing using apt"
  sudo apt install git
fi

# TODO - Install from source
function install_from_src() {
}

ppi "Creating symlink for .gitconfig"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig