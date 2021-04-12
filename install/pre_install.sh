#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

function pre_install_mac() {
    ppi "Checking for Homebrew install."
    if test ! $(which brew); then
        grep 199.232.28.133 /etc/hosts -c || sudo -- sh -c "echo 199.232.28.133 raw.githubusercontent.com >> /etc/hosts"

        ppi "Homebrew not found, downloading installer and installing"
        /bin/bash -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
    fi

    if test ! $(which brew); then
        ppw "Brew install failed. Exiting..."
        exit
    fi
}

function pre_install_linux() {
    ppi "No Linux pre-install, skipping..."
}

function pre_install_android() {
    ppi "Allow termux access to local storage"
    termux-setup-storage

    ppi "Symlinking termux config files"
    mkdir -p $HOME/.termux
    rm -rf $HOME/.termux/colors.properties
    rm -rf $HOME/.termux/termux.properties
    ln -s $HOME/.dotfiles/termux/colors.properties $HOME/.termux/colors.properties
    ln -s $HOME/.dotfiles/termux/termux.properties $HOME/.termux/termux.properties
}

if [[ $(uname -a|grep "Darwin") ]]; then
    pre_install_mac
elif [[ $(uname -a|grep "Android") ]]; then
    pre_install_android
else
    pre_install_linux
fi

source $HOME/.dotfiles/install/update.sh
