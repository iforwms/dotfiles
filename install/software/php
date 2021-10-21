#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install php
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install php
else
  ppi "Installing using apt-get"
  sudo apt-get install -y php
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .php"
# rm -rf $HOME/.php
# ln -s $HOME/.dotfiles/.php $HOME/.php
