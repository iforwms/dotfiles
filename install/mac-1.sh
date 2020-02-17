#!/bin/bash

# Macbook/iMac only setup
sudo -v

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
