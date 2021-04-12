#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install tmux
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install tmux
else
  ppi "Installing using apt"
  sudo apt install -y tmux
fi

# TODO - Install from source
function install_from_src() {
  ppi "Installing libevent"
  tar -zxf libevent-*.tar.gz
  cd libevent-*/
  ./configure --prefix=$HOME/local --enable-shared
  make && make install

  ppi "Installing ncurses"
  tar -zxf ncurses-*.tar.gz
  cd ncurses-*/
  ./configure --prefix=$HOME/local --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$HOME/local/lib/pkgconfig
  make && make install

  ppi "Downloading tmux tarball"

  ppi "Installing tmux..."
  tar -zxf tmux-*.tar.gz
  cd tmux-*/
  ./configure
  make && sudo make install
}

ppi "Creating symlink for .tmux.conf"
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
