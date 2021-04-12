#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install jq
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install jq
else
  ppi "Installing using apt"
  sudo apt install jq
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .jq"
# rm -rf $HOME/.jq
# ln -s $HOME/.dotfiles/.jq $HOME/.jq
