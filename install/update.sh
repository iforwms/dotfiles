#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Updating Homebrew"
  brew update
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Updating pkg definitions"
  pkg upgrade
else
  ppi "Updating apt-get"
  sudo apt-get update
fi

