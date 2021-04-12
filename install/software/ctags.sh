#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install ctags
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install ctags
else
  ppi "Installing using apt-get"
  sudo apt-get install -y ctags
fi

# TODO - Install from source
function install_from_src() {
}

ppi "Creating symlink for .ctags"
rm -rf $HOME/.ctags
ln -s $HOME/.dotfiles/.ctags $HOME/.ctags
