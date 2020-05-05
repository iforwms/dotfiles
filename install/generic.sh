#!/bin/bash

RAW_GIT=https://raw.githubusercontent.com
RAW_GIT=https://iforwms.com/music/setup
echo "Setting up ZSH"
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Downloading ZSH plugins"
rm -rf $HOME/.dotfiles/plugins/zsh-syntax-highlighting
rm -rf $HOME/.dotfiles/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

echo "Setting up Vim"
rm -rf $HOME/.vim
ln -s $HOME/.dotfiles/.vim $HOME/.vim

echo "Installing php vim syntax highlighting"
curl -fsSL -o $HOME/.dotfiles/.vim/syntax/php.vim $RAW_GIT/StanAngeloff/php.vim/master/syntax/php.vim

echo "Installing vim color scheme"
curl -fsSL -o $HOME/.dotfiles/.vim/colors/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/colors/onedark.vim
curl -fsSL -o $HOME/.dotfiles/.vim/autoload/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/autoload/onedark.vim

echo "Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

echo "Install tmux navigator vim plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/tmux_navigator.vim $RAW_GIT/christoomey/vim-tmux-navigator/master/plugin/tmux_navigator.vim

echo "Install vim surround plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/surround.vim $RAW_GIT/tpope/vim-surround/master/plugin/surround.vim

echo "Install vim commentary plugin"
curl -fsSL -o $HOME/.dotfiles/.vim/plugin/commentary.vim $RAW_GIT/tpope/vim-commentary/master/plugin/commentary.vim

echo "Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

echo "Creating symlink for .ctags"
rm -rf $HOME/.ctags
ln -s $HOME/.dotfiles/.ctags $HOME/.ctags

echo "Symlink .gitconfig file to the home directory"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
