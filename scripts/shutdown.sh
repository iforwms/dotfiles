#!/bin/bash

echo " Checking repos..."

modifiedArray=()
unpushed=()

while read line; do
    repoPath=`echo $line | sed "s/\/.git//"`

    # echo -e "\033[1;35m" Processing repo: $repoPath"\033[0;37m"

    modified=`git -C $repoPath status -s`
    if [[ ! -z "$modified" ]]; then
        modifiedArray+=( "$repoPath" )
    fi

done < <(find $HOME/code -mindepth 1 -maxdepth 4 -type d -name .git -prune)

modifiedLength="${#modifiedArray[@]}"
if ((modifiedLength > 0)); then
    echo
    echo -e "\033[1;35m" Found $modifiedLength modified repos:"\033[0;37m"
    echo

    for i in "${modifiedArray[@]}"
    do
        echo " " $i
    done
fi

