#!/bin/bash

echo 'Installing FZF'
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Installing FZF plugin"
git clone https://github.com/junegunn/fzf.vim $HOME/.dotfiles/.vim/pack/default/start/fzf.vim

echo "Installing FZF checkout plugin"
git clone https://github.com/stsewd/fzf-checkout.vim $HOME/.dotfiles/.vim/pack/default/start/fzf-checkout.vim

echo 'Installing rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo 'Installing ripgrep'
cargo install ripgrep
