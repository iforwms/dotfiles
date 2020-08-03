#!/bin/bash

repoName=`basename $(pwd)`
branchName=`git rev-parse --abbrev-ref HEAD`
status=`git status -s`

echo
echo -e "\033[1;35m" $repoName" \033[2;35m["$branchName"]\033[0;37m"
echo

# If files are modified, show details
if [[ ! -z "$status" ]]; then
    git status | head -2 | tail -1 | awk '{print " " $0}'
    echo
    git status -s
else
    echo " No local changes."
fi

echo

git pull

echo
echo "--"
