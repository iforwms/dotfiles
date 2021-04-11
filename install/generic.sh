#!/bin/bash

RAW_GIT=https://raw.githubusercontent.com
# RAW_GIT=https://iforwms.com/music/setup

echo "[TMUX] Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

echo "[CTAGS] Creating symlink for .ctags"
rm -rf $HOME/.ctags
ln -s $HOME/.dotfiles/.ctags $HOME/.ctags

echo "[GIT] Creating symlink for .gitconfig"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
