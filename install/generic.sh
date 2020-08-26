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

echo "[VIM] Setting up..."
rm -rf $HOME/.vim
ln -s $HOME/.dotfiles/.vim $HOME/.vim

echo "[VIM] Creating plugin directory"
mkdir -p $HOME/.dotfiles/.vim/pack/default/start

echo "[VIM] Installing syntax highlighting plugin"
git clone https://github.com/sheerun/vim-polyglot $HOME/.dotfiles/.vim/pack/default/start/vim-polyglot
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-polyglot/doc" -c q

echo "[VIM] Installing abolish plugin"
git clone https://github.com/tpope/vim-abolish $HOME/.dotfiles/.vim/pack/default/start/vim-abolish
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-abolish/doc" -c q

echo "[VIM] Installing surround plugin"
git clone https://github.com/tpope/vim-surround $HOME/.dotfiles/.vim/pack/default/start/vim-surround
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-surround/doc" -c q

echo "[VIM] Installing commentary plugin"
git clone https://github.com/tpope/vim-commentary $HOME/.dotfiles/.vim/pack/default/start/vim-commentary
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-commentary/doc" -c q

echo "[VIM] Installing FZF plugin"
git clone https://github.com/junegunn/fzf.vim $HOME/.dotfiles/.vim/pack/default/start/fzf.vim
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/fzf.vim/doc" -c q

echo "[VIM] Installing PHP import namespace plugin"
git clone https://github.com/arnaud-lb/vim-php-namespace $HOME/.dotfiles/.vim/pack/default/start/vim-php-namespace

echo "[VIM] Installing onedark color scheme"
curl -fsSL -o $HOME/.dotfiles/.vim/colors/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/colors/onedark.vim
curl -fsSL -o $HOME/.dotfiles/.vim/autoload/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/autoload/onedark.vim

echo "[VIM] Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

echo "[TMUX] Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

echo "[CTAGS] Creating symlink for .ctags"
rm -rf $HOME/.ctags
ln -s $HOME/.dotfiles/.ctags $HOME/.ctags

echo "[GIT] Creating symlink for .gitconfig"
rm -rf $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
