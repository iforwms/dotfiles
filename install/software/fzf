#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi 'Installing FZF'
rm -rf $HOME/.fzf
git clone --depth 1 git@github.com:junegunn/fzf.git ~/.fzf
~/.fzf/install

ppi 'Installing rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

ppi 'Installing ripgrep'
cargo install ripgrep
