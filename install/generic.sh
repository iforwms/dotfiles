#!/bin/bash

RAW_GIT=https://raw.githubusercontent.com
# RAW_GIT=https://iforwms.com/music/setup

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

echo "[r2] Creating symlink for .radare2rc"
rm -rf $HOME/.radare2rc
ln -s $HOME/.dotfiles/.radare2rc $HOME/.radare2rc

echo "[TMUX] Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

echo "[CTAGS] Creating symlink for .ctags"
rm -rf $HOME/.ctags
ln -s $HOME/.dotfiles/.ctags $HOME/.ctags

echo "[GIT] Creating symlink for .gitconfig"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

echo "[FZF] Installing FZF, ripgrep and rust"
/bin/bash $HOME/.dotfiles/scripts/fzf.sh
