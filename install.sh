#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Update Homebrew recipes"
brew update

echo "Install all our dependencies with bundle (See Brewfile)"
brew tap homebrew/bundle
brew bundle

echo "Install PHP extensions with PECL"
pecl install memcached imagick

echo "Install global Composer packages"
/usr/local/bin/composer global require laravel/installer

# Install Laravel Valet
# $HOME/.composer/vendor/bin/valet install

echo "Create a Code directory"
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/code

echo "Setting up ZSH"
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Creating ZSH custom plugins directory"
mkdir -p $HOME/.dotfiles/plugins

echo "Download ZSH plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

echo "Download Vim colour scheme"
mkdir -p $HOME/.vim/colors
curl -o $HOME/.vim/colors/Benokai.vim 'https://raw.githubusercontent.com/benjaminwhite/Benokai/master/colors/Benokai.vim'

echo "Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

echo "Symlink the Mackup config file to the home directory"
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

echo "Set macOS preferences"
# We will run this last because this will reload the shell
source .macos
