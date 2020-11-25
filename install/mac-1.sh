#!/bin/bash
HOMEBREW_INSTALL_URL="123"

# Macbook/iMac only setup
sudo -v

echo "Setting up your Mac..."

echo "Installing CLI tools for Xcode"
xcode-select --install 2>/dev/null

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  grep 199.232.28.133 /etc/hosts -c || sudo -- sh -c "echo 199.232.28.133 raw.githubusercontent.com >> /etc/hosts"

  echo "Homebrew not found, downloading installer"
#  bash -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
  /bin/bash -c "$(curl -fsSL https://iforwms.com/music/brew_install.sh)"
fi

if test ! $(which brew); then
  echo "Brew install failed. Exiting..."
  exit
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

echo "Installing jtc"
curl -fsSL -o $HOME/jtc https://github.com/ldn-softdev/jtc/releases/download/LatestBuild/jtc-macos-64.latest
chmod 754 $HOME/jtc
xattr -dr com.apple.quarantine $HOME/jtc
mv $HOME/jtc /usr/local/bin/

echo "Setting up chessx config"
rm -rf $HOME/.config/chessx
mkdir $HOME/.config
ln -s $HOME/.dotfiles/chessx $HOME/.config/chessx
