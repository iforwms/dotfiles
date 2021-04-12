#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi "Creating symlink for .radare2rc"
rm -rf $HOME/.radare2rc
ln -s $HOME/.dotfiles/.radare2rc $HOME/.radare2rc

