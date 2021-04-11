#!/bin/bash

echo "[ZSH] Setting up..."
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "[ZSH] Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "[ZSH] Downloading plugins..."
rm -rf $HOME/.dotfiles/plugins/zsh-syntax-highlighting
rm -rf $HOME/.dotfiles/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

