#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi "Cloning repo..."
rm -rf $HOME/.oh-my-zsh
git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

ppi "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

ppi "Downloading plugins..."
rm -rf $HOME/.dotfiles/plugins/zsh-syntax-highlighting
rm -rf $HOME/.dotfiles/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

ppi "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
