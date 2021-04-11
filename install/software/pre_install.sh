#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

function pre_install_mac() {
  ppi "Pre install mac"
}

function pre_install_linux() {
  ppi "Pre install linux"
}

function pre_install_android() {
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
  pre_install_mac
elif [[ $(uname -a|grep "Android") ]]; then
  pre_install_android
else
  pre_install_linux
fi
