#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

function post_update_mac() {
  ppi "Post update mac"
}

function post_update_linux() {
  ppi "Post update linux"
}

function post_update_android() {
  ppi "Allow termux access to local storage"
  termux-setup-storage

  ppi "Symlinking termux config files"
  mkdir -p $HOME/.termux
  rm -rf $HOME/.termux/colors.properties
  rm -rf $HOME/.termux/termux.properties
  ln -s $HOME/.dotfiles/termux/colors.properties $HOME/.termux/colors.properties
  ln -s $HOME/.dotfiles/termux/termux.properties $HOME/.termux/termux.properties
}

if [[ $(uname -a|grep "Darwin") ]]; then
  post_update_mac
elif [[ $(uname -a|grep "Android") ]]; then
  post_update_android
else
  post_update_linux
fi
