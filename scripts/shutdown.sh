#!/bin/bash

echo "Checking for unpushed repos."
# Search for any unpushed or unstaged changes in all repos
# If unpushed at to array
# If modified, at to another array
# If any unpushed or modified, stop shutdown and list all repos
modifiedArray=()
# unpushed=()

while read line; do
    repoPath=`echo $line | sed "s/\/.git//"`

    echo
    echo -e "\033[1;35m" Processing repo: $repoPath"\033[0;37m"
    echo

    # checkStatus $line
    # modified+=$1

    modified=`git -C $repoPath status -s`
    if [[ ! -z "$modified" ]]; then
        modifiedArray+=( "$repoPath" )
    fi
done < <(find $HOME/code -mindepth 1 -maxdepth 4 -type d -name .git -prune)

echo "${modifiedArray[@]}"
# echo "${unpushed[@]}"
