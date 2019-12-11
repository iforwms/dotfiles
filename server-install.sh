#!/bin/sh

echo "Setting up your Server..."
sudo -v

echo "Updating repositories"
sudo apt update

echo "Upgrading packages"
sudo apt upgrade -y

# TODO
# Install Yarn, Node, Composer

echo "Installing ZSH"
sudo apt install zsh
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Creating ZSH custom plugins directory"
mkdir -p $HOME/.dotfiles/plugins

echo "Download ZSH plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${$HOME/.dotfiles}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${$HOME/.dotfiles}/plugins/zsh-autosuggestions

echo "Setting ZSH as default shell"
chsh -s $(which zsh)

echo "Download Vim colour scheme"
mkdir -p $HOME/.vim/colors
curl -o $HOME/.vim/colors/Benokai.vim 'https://raw.githubusercontent.com/benjaminwhite/Benokai/master/colors/Benokai.vim'

echo "Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
