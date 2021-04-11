#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

MISSING=""

for i in "$@"
do
    INSTALLER="$HOME/.dotfiles/install/software/$i.sh"

    if [[ -f $INSTALLER ]]; then
        ppi "Installing $i..."
        $INSTALLER
    else
        MISSING="$i ${MISSING}"
    fi
done;

if [[ $MISSING != "" ]]; then
    ppw "The installer for the following do not exist: $MISSING"
fi
