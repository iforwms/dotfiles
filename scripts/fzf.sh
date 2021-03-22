#!/bin/bash

echo 'Installing FZF'
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Installing FZF plugin"
rm -rf $HOME/.vim/pack/default/start/fzf
rm -rf $HOME/.vim/pack/default/start/fzf.vim
git clone https://github.com/junegunn/fzf.git ~/.vim/pack/default/start/fzf
git clone https://github.com/junegunn/fzf.vim $HOME/.dotfiles/.vim/pack/default/start/fzf.vim

echo "Installing FZF checkout plugin"
rm -rf $HOME/.vim/pack/default/start/fzf-checkout.vim
git clone https://github.com/stsewd/fzf-checkout.vim $HOME/.dotfiles/.vim/pack/default/start/fzf-checkout.vim

echo 'Installing rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo 'Installing ripgrep'
cargo install ripgrep
