#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

MISSING=""
FAILED=""

for COMMAND in "$@"
do
    if [[ $COMMAND == "pre_install" ]] || [[ $COMMAND == "post_install" ]]; then
        INSTALLER="$HOME/.dotfiles/install/$COMMAND.sh"
    else
        INSTALLER="$HOME/.dotfiles/install/software/$COMMAND.sh"
    fi

    if [[ -f $INSTALLER ]]; then
        # if command -v $COMMAND &> /dev/null
        # then
            # ppi "$COMMAND already installed, skipping"
        # else
            ppi "Installing $COMMAND..."
            EXIT_CODE=$INSTALLER
            if [[ $EXIT_CODE != 0 ]]; then
                FAILED="${FAILED} $INSTALLER"
            fi
        # fi
    else
        MISSING="$COMMAND ${MISSING}"
    fi
done;

if [[ $MISSING != "" ]]; then
    ppw "The installer for the following do not exist: $MISSING"
fi

if [[ $FAILED != "" ]]; then
    ppw "Failed to install the following: $FAILED"
fi
