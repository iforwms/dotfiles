#!/bin/bash

if [ -z $1 ] || (( $1 < 1 )) || (( $1 > 4 ))
then
    echo "Please choose an installation type:"
    echo "1: Server"
    echo "2: iMac"
    echo "3: MacBook"
    echo "4: Termux"
    echo ""
    echo "Usage: ./install.sh [type]"
    exit
fi

echo "Creating a Code directory"
mkdir $HOME/code 2> /dev/null

if (( $1 == 1 ))
then
    source install/server.sh
elif (( $1 < 4 ))
then
    source install/mac-1.sh
else
    source install/termux.sh
fi

source install/generic.sh

if (( $1 > 1 && $1 < 4 )); then
    source install/mac-2.sh
fi
