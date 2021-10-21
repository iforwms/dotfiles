#!/bin/bash

echo " Checking repos..."

modifiedArray=()
unpushed=()
dirty=false

while read line; do
    repoPath=`echo $line | sed "s/\/.git//"`

    modified=`git -C $repoPath status -s`
    if [[ ! -z "$modified" ]]; then
        modifiedArray+=( "$repoPath" )
    fi

    unpushed=`git -C $repoPath cherry -v 2>/dev/null`
    if [[ ! -z "$unpushed" ]]; then
        unpushedArray+=( "$repoPath" )
    fi

done < <(find -L $HOME/code -mindepth 1 -maxdepth 4 -type d -name .git -prune)

modifiedLength="${#modifiedArray[@]}"
if ((modifiedLength > 0)); then
    dirty=true
    echo
    echo -e "\033[1;35m" Found $modifiedLength modified repos:"\033[0;37m"
    echo

    for i in "${modifiedArray[@]}"
    do
        echo " " $i
    done
fi

unpushedLength="${#unpushedArray[@]}"
if ((unpushedLength > 0)); then
    dirty=true
    echo
    echo -e "\033[1;35m" Found $unpushedLength unpushed repos:"\033[0;37m"
    echo

    for i in "${unpushedArray[@]}"
    do
        echo " " $i
    done
fi

if [[ ! "$dirty" = true ]]; then
    read -p "Nothing to push, are you sure you want to shutdown? (y/n) " -n 1 -r

    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Aborting shutdown..."
        exit 1
    fi

    echo "Shutting down..."
    sudo shutdown -h now
fi
