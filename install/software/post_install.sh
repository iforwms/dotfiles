#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

function post_install_mac() {
    sudo -v

    ppi "Symlink Mackup config file and folder to the home directory"
    rm -rf $HOME/.mackup.cfg
    ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg
    rm -rf $HOME/.mackup
    ln -s $HOME/.dotfiles/mackup $HOME/.mackup

    ppi "Setting up lilypond"
    ln -s $HOME/.dotfiles/lilypond/lilypond-link /usr/local/bin/lilypond-link
    chmod +x /usr/local/bin/lilypond-link

    ppi "Cloning lilypond vim syntax highlighting"
    git clone git@github.com:matze/vim-lilypond.git $HOME/.dotfiles/lilypond/vim

    ppi "Installing tmux cmus plugin"
    git clone https://github.com/Mpdreamz/tmux-cmus $HOME/.dotfiles/tmux/tmux-cmus

    ppi "Setting up terminfo config"
    ppw "Remember to update iterm (Preferences > Profiles > Terminal > Report Terminal Type: > xterm-256color-italic)"
    tic $HOME/.dotfiles/tmux/256-italic-terminfo
    tic -x $HOME/.dotfiles/tmux/tmux-terminfo

    # ppi "Installing beets"
    # pip3 install beets
    # ppi "Setting up beets"
    # mkdir -p $HOME/.config/beets
    # rm -rf $HOME/.config/beets/config.yaml
    # ln -s $HOME/.dotfiles/beets/config.yaml $HOME/.config/beets/config.yaml

    ppi "Installing CLI tools for Xcode"
    xcode-select --install 2>/dev/null

    ppi "Updating macOS preferences"
    # We will run this last because this will reload the shell
    source .macos
}

function post_install_linux() {
    ppi "No Linux post-install, skipping..."
}

function post_install_android() {
    ppi "No Android post-install, skipping..."
}

if [[ $(uname -a|grep "Darwin") ]]; then
    post_install_mac
elif [[ $(uname -a|grep "Android") ]]; then
    post_install_android
else
    post_install_linux
fi
