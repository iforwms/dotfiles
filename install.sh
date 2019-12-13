#!/bin/sh

install_type=$1

if [[ $install_type -eq 0 ]] || [[ $install_type -gt 3 ]]; then
    echo "Please choose an installation type:"
    echo "1: Server"
    echo "2: iMac"
    echo "3: MacBook"
    echo ""
    echo "Usage: ./install.sh [type]"
    exit
fi

sudo -v

if [[ $install_type -eq 1 ]]; then
    echo "Setting up server..."

    echo "Updating repositories"
    sudo apt update

    echo "Upgrading packages"
    sudo apt upgrade -y

    # TODO
    # Install Yarn, Node, Composer

    echo "Installing ZSH"
    sudo apt install -y zsh
else
    echo "Setting up your Mac..."

    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Updating Homebrew recipes"
    brew update

    echo "Installing all brew dependencies (See Brewfile)"
    brew tap homebrew/bundle
    brew bundle

    echo "Installing PHP extensions with PECL"
    pecl install memcached imagick

    echo "Installing global Composer packages"
    /usr/local/bin/composer global require laravel/installer

    # Install Laravel Valet
    # $HOME/.composer/vendor/bin/valet install

    echo "Creating a Code directory"
    # This is a default directory for macOS user accounts but doesn't comes pre-installed
    mkdir $HOME/code
fi

echo "Setting up ZSH"
rm -rf $HOME/.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "Creating symlink for .zshrc"
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

echo "Creating ZSH custom plugins directory"
mkdir -p $HOME/.dotfiles/plugins

echo "Downloading ZSH plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/plugins/zsh-autosuggestions

echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

echo "Downloading Vim colour scheme"
mkdir -p $HOME/.vim/colors
curl -o $HOME/.vim/colors/Benokai.vim 'https://raw.githubusercontent.com/benjaminwhite/Benokai/master/colors/Benokai.vim'

echo "Creating symlink for .vimrc"
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc

if [[ $install_type -gt 1 ]]; then
    echo "Symlink Mackup config file to the home directory"
    rm -rf $HOME/.mackup.cfg
    ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

    echo "Updating macOS preferences"
    # We will run this last because this will reload the shell
    source .macos
fi
