#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi "Setting up chessx config"
rm -rf $HOME/.config/chessx
mkdir $HOME/.config
ln -s $HOME/.dotfiles/chessx $HOME/.config/chessx

