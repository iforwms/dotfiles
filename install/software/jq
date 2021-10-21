#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install jq
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install jq
else
  ppi "Installing using apt-get"
  sudo apt-get install -y jq
fi

function install_from_src() {
    ppi "TODO"
}

# ppi "Creating symlink for .jq"
# rm -rf $HOME/.jq
# ln -s $HOME/.dotfiles/.jq $HOME/.jq
