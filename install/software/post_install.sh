#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

function post_install_mac() {
  ppi "Post install mac"
}

function post_install_linux() {
  ppi "Post install linux"
}

function post_install_android() {
  ppi "Post install android"
}

if [[ $(uname -a|grep "Darwin") ]]; then
  post_install_mac
elif [[ $(uname -a|grep "Android") ]]; then
  post_install_android
else
  post_install_linux
fi
