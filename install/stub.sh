#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install {{STUB}}
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install {{STUB}}
else
  ppi "Installing using apt"
  sudo apt install {{STUB}}
fi

# TODO - Install from source
function install_from_src() {
}

# ppi "Creating symlink for .{{STUB}}"
# rm -rf $HOME/.{{STUB}}
# ln -s $HOME/.dotfiles/.{{STUB}} $HOME/.{{STUB}}
