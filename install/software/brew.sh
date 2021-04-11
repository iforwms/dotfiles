#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  grep 199.232.28.133 /etc/hosts -c || sudo -- sh -c "echo 199.232.28.133 raw.githubusercontent.com >> /etc/hosts"

  ppi "Homebrew not found, downloading installer"
  /bin/bash -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
fi

if test ! $(which brew); then
  ppw "Brew install failed. Exiting..."
  exit
fi

ppi "Updating Homebrew recipes"
brew update

ppi "Installing all brew dependencies (See Brewfile)"
brew tap homebrew/bundle
brew bundle

