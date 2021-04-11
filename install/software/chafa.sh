#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

ppi "Installing chafa"
sudo add-apt-repository ppa:hpjansson/chafa
sudo apt install chafa
