#!/bin/sh

echo "Setting up your Server..."

# echo "Updating repositories"
# sudo apt update

# echo "Upgrading packages"
# sudo apt upgrade

echo "Installing ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Setting ZSH as default shell"
chsh -s $(which zsh)

echo "Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Download ZSH plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "Download Vim colour scheme"
mkdir $HOME/.vim/colors
curl -o $HOME/.vim/colors/Benokai.vim 'https://raw.githubusercontent.com/benjaminwhite/Benokai/master/colors/Benokai.vim'

echo "Removes .vimrc from $HOME (if it exists) and symlinks the .vimrc file from the .dotfiles"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
