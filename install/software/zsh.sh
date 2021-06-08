#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ $(uname -a|grep "Darwin") ]]; then
  ppi "Installing using Homebrew"
  brew install zsh
elif [[ $(uname -a|grep "Android") ]]; then
  ppi "Installing using pkg"
  pkg install zsh
else
  ppi "Installing using apt-get"
  sudo apt-get install -y zsh
fi

ppi "Cloning repo..."
rm -rf $HOME/.oh-my-zsh
git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

ppi "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

ppi "Downloading plugins..."
rm -rf $HOME/.dotfiles/zsh/plugins/zsh-autosuggestions
rm -rf $HOME/.dotfiles/zsh/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/zsh/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/zsh/plugins/zsh-syntax-highlighting

ppi "Setting ZSH as default shell"
if [[ $(uname -a|grep "Android") ]]; then
    chsh -s $(which zsh)
else
    sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
fi
