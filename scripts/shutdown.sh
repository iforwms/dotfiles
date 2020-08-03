#!/bin/bash

echo " Checking repos..."

modifiedArray=()
unpushed=()

while read line; do
    repoPath=`echo $line | sed "s/\/.git//"`

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

unpushedLength="${#unpushedArray[@]}"
if ((unpushedLength > 0)); then
    echo
    echo -e "\033[1;35m" Found $unpushedLength unpushed repos:"\033[0;37m"
    echo

    for i in "${unpushedArray[@]}"
    do
        echo " " $i
    done
fi
