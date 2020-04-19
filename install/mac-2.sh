#!/bin/bash

echo "Setting ZSH as default shell"
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

echo "Symlink Mackup config file and folder to the home directory"
rm -rf $HOME/.mackup.cfg
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg
rm -rf $HOME/.mackup
ln -s $HOME/.dotfiles/mackup $HOME/.mackup

echo "Setting up lilypond"
ln -s $HOME/.dotfiles/lilypond/lilypond-link /usr/local/bin/lilypond-link
chmod +x /usr/local/bin/lilypond-link

echo "Cloning lilypond vim syntax highlighting"
git clone git@github.com:matze/vim-lilypond.git $HOME/.dotfiles/lilypond/vim

echo "Installing tmux cmus plugin"
git clone https://github.com/Mpdreamz/tmux-cmus $HOME/.dotfiles/tmux/tmux-cmus

# TODO: Install cmus playlists

echo "Seting up terminfo config"
echo "## remember to update iterm (Preferences > Profiles > Terminal > Report Terminal Type: > xterm-256color-italic)"
tic $HOME/.dotfiles/tmux/256-italic-terminfo
tic -x $HOME/.dotfiles/tmux/tmux-terminfo

# Install python?
# echo "Installing beets"
# pip3 install beets
# echo "Setting up beets"
# mkdir -p $HOME/.config/beets
# rm -rf $HOME/.config/beets/config.yaml
# ln -s $HOME/.dotfiles/beets/config.yaml $HOME/.config/beets/config.yaml

echo "Updating macOS preferences"
# We will run this last because this will reload the shell
source .macos
