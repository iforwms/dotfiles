#!/bin/bash

# Macbook/iMac only setup
sudo -v

echo "Setting up the Mac..."

echo "Installing CLI tools for Xcode"
xcode-select --install 2>/dev/null

echo "Installing PHP extensions with PECL"
pecl install memcached imagick

echo "Installing global Composer packages"
/usr/local/bin/composer global require laravel/installer
