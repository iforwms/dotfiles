#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [ -z $1 ] || (( $1 < 1 )) || (( $1 > 4 ))
then
    echo "Choose an installation type:"
    echo "1: Server"
    echo "2: iMac"
    echo "3: MacBook"
    echo "4: Termux"
    echo
    echo "Usage: ./install.sh [type]"
    exit
fi

GENERIC="\
    ../pre_install \
    zsh \
    vim \
    git \
    tmux \
    xclip \
    node \
    yarn \
    tree  \
    php  \
    python  \
    nmap  \
    ncat  \
"
GENERIC="../pre_install"

TO_INSTALL=$GENERIC

MAC="\
    brew \
"

TERMUX="\
"

SERVER="\
    chafa \
"

ppi "Creating a code directory in $HOME"
mkdir $HOME/code 2> /dev/null

if (( $1 == 1 ))
then
    TO_INSTALL="${TO_INSTALL} ${SERVER}"
elif (( $1 == 4 ))
then
    TO_INSTALL="${TO_INSTALL} ${TERMUX}"
else
    TO_INSTALL="${TO_INSTALL} ${MAC}"
fi

TO_INSTALL="${TO_INSTALL} ../post_install"

$HOME/.dotfiles/install/installer.sh $TO_INSTALL
