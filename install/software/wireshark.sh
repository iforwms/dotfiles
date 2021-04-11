#!/bin/bash

echo "Creating symlink for wireshark config"
rm -rf $HOME/.config/wireshark
ln -s $HOME/.dotfiles/wireshark $HOME/.config/wireshark
