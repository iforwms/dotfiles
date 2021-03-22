#!/bin/bash

RAW_GIT=https://raw.githubusercontent.com

echo "[VIM] Setting up..."
rm -rf $HOME/.vim
ln -s $HOME/.dotfiles/.vim $HOME/.vim

echo "[VIM] Creating plugin directory"
mkdir -p $HOME/.dotfiles/.vim/pack/default/start

echo "[VIM] Installing syntax highlighting plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-polyglot
git clone https://github.com/sheerun/vim-polyglot $HOME/.dotfiles/.vim/pack/default/start/vim-polyglot
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-polyglot/doc" -c q

echo "[VIM] Installing abolish plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-abolish
git clone https://github.com/tpope/vim-abolish $HOME/.dotfiles/.vim/pack/default/start/vim-abolish
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-abolish/doc" -c q

echo "[VIM] Installing surround plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-surround
git clone https://github.com/tpope/vim-surround $HOME/.dotfiles/.vim/pack/default/start/vim-surround
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-surround/doc" -c q

echo "[VIM] Installing Wakatime plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-wakatime
git clone https://github.com/wakatime/vim-wakatime $HOME/.dotfiles/.vim/pack/default/start/vim-wakatime
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-wakatime/doc" -c q

echo "[VIM] Installing documentation plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-doge
git clone --depth 1 https://github.com/kkoomen/vim-doge $HOME/.dotfiles/.vim/pack/default/start/vim-doge
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-doge/doc" -c q

echo "[VIM] Installing rust plugin"
rm -rf $HOME/.dotfiles/.vim/pack/plugins/start/rust.vim
git clone https://github.com/rust-lang/rust.vim $HOME/.dotfiles/.vim/pack/plugins/start/rust.vim
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-commentary/doc" -c q

echo "[VIM] Installing commentary plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-commentary
git clone https://github.com/tpope/vim-commentary $HOME/.dotfiles/.vim/pack/default/start/vim-commentary
# vim -u NONE -c "helptags $HOME/.dotfiles/.vim/pack/default/start/vim-commentary/doc" -c q

echo "[VIM] Installing Vim Fugitive checkout plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-fugitive
git clone https://github.com/tpope/vim-fugitive $HOME/.dotfiles/.vim/pack/default/start/vim-fugitive

echo "[VIM] Installing PHP import namespace plugin"
rm -rf $HOME/.dotfiles/.vim/pack/default/start/vim-php-namespace
git clone https://github.com/arnaud-lb/vim-php-namespace $HOME/.dotfiles/.vim/pack/default/start/vim-php-namespace

echo "[VIM] Installing coc"
COC_INSTALL=$HOME/.dotfiles/.vim/pack/coc/start
rm -rf $COC_INSTALL
mkdir -p $COC_INSTALL
curl -fsSL -o $COC_INSTALL/release.tar.gz https://github.com/neoclide/coc.nvim/archive/release.tar.gz
tar -xzf $COC_INSTALL/release.tar.gz
# rm $COC_INSTALL/release.tar.gz

echo "[VIM] Installing onedark color scheme"
rm -rf $RAW_GIT/joshdick/onedark.vim/master/colors/onedark.vim
rm -rf $RAW_GIT/joshdick/onedark.vim/master/autoload/onedark.vim
curl -fsSL -o $HOME/.dotfiles/.vim/colors/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/colors/onedark.vim
curl -fsSL -o $HOME/.dotfiles/.vim/autoload/onedark.vim $RAW_GIT/joshdick/onedark.vim/master/autoload/onedark.vim

echo "[VIM] Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

