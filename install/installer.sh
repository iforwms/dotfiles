#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

MISSING=""

for COMMAND in "$@"
do
    INSTALLER="$HOME/.dotfiles/install/software/$COMMAND.sh"

    if [[ -f $INSTALLER ]]; then
        if command -v $COMMAND &> /dev/null
        then
            ppi "$COMMAND already installed, skipping"
        else
            ppi "Installing $COMMAND..."
            $INSTALLER
        fi
    else
        MISSING="$COMMAND ${MISSING}"
    fi
done;

if [[ $MISSING != "" ]]; then
    ppw "The installer for the following do not exist: $MISSING"
fi
