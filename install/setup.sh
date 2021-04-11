#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [ -z $1 ] || (( $1 < 1 )) || (( $1 > 4 ))
then
    echo "Please choose an installation type:"
    echo "1: Server"
    echo "2: iMac"
    echo "3: MacBook"
    echo "4: Termux"
    echo
    echo "Usage: ./install.sh [type]"
    exit
fi

GENERIC="\
    vim \
    git \
    tmux \
"
GENERIC="whop"

TO_INSTALL=$GENERIC

MAC="\
    mac_specific \
"

TERMUX="\
    termux_special \
"

SERVER="\
    test \
"

echo
ppi "Creating a code directory in $HOME"
mkdir $HOME/code 2> /dev/null

if (( $1 == 1 ))
then
    TO_INSTALL="${TO_INSTALL} ${SERVER}"
    # source $HOME/.dotfiles/install/server.sh
elif (( $1 == 4 ))
then
    TO_INSTALL="${TO_INSTALL} ${TERMUX}"
    # source $HOME/.dotfiles/install/mac-1.sh
else
    TO_INSTALL="${TO_INSTALL} ${MAC}"
    # source $HOME/.dotfiles/install/termux.sh
fi

$HOME/.dotfiles/install/installer.sh $TO_INSTALL

# source $HOME/.dotfiles/install/generic.sh

# if (( $1 > 1 && $1 < 4 )); then
#     source $HOME/.dotfiles/install/mac-2.sh
# fi
