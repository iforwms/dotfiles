#!/bin/sh

echo "Setting up your Server..."
sudo -v

echo "Updating repositories"
sudo apt update

echo "Upgrading packages"
sudo apt upgrade

# TODO
# Install Yarn, Node, Composer

echo "Installing ZSH"
sudo apt install zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Setting ZSH as default shell"
chsh -s $(which zsh)

echo "Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Download ZSH plugins"
mkdir -p ${ZSH_CUSTOM}/plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "Download Vim colour scheme"
mkdir -p $HOME/.vim/colors
curl -o $HOME/.vim/colors/Benokai.vim 'https://raw.githubusercontent.com/benjaminwhite/Benokai/master/colors/Benokai.vim'

echo "Removes .vimrc from $HOME (if it exists) and symlinks the .vimrc file from the .dotfiles"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
