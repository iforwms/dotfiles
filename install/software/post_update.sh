#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install tmux
elif [[ $(uname -a|grep "Android") ]]; then
  post_update_android()
else
  ppi "Installing using apt"
  sudo apt install tmux
fi

function post_update_android() {
  ppi "Allow termux access to local storage"
  termux-setup-storage

  ppi "Symlinking termux config files"
  mkdir -p $HOME/.termux
  ln -s $HOME/.dotfiles/termux/colors.properties $HOME/.termux/colors.properties
  ln -s $HOME/.dotfiles/termux/termux.properties $HOME/.termux/termux.properties
}
