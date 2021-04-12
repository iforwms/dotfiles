#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install htop
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install htop
else
  ppi "Installing using apt"
  sudo apt install -y htop
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .htop"
# rm -rf $HOME/.htop
# ln -s $HOME/.dotfiles/.htop $HOME/.htop
