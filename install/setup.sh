#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [ -z $1 ] || (( $1 < 1 )) || (( $1 > 4 ))
then
    echo
    echo "   Choose an installation type:"
    echo
    echo "   1: Server"
    echo "   2: iMac"
    echo "   3: MacBook"
    echo "   4: Termux"
    echo
    echo "   Usage: ./setup.sh [type]"
    echo
    exit
fi

GENERIC="\
    pre_install \
    wget \
    curl \
    git \
    zsh \
    python  \
    php  \
    composer \
    vim \
    tmux \
    node \
    yarn \
    jq \
    tree  \
    watch \
    imagemagick \
    nmap  \
    ncat  \
"

TO_INSTALL=$GENERIC

MAC="\
    brew \
    mysql \
    nginx \
    burpsuite \
"

TERMUX="\
    xclip \
    htop \
"

SERVER="\
    chafa \
    htop \
    mysql \
    nginx \
    xclip \
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

TO_INSTALL="${TO_INSTALL} post_install"

$HOME/.dotfiles/install/installer.sh $TO_INSTALL
