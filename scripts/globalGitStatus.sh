#!/bin/bash

repoName=`basename $(pwd)`
branchName=`git rev-parse --abbrev-ref HEAD`
status=`git status -s`

# If status, show details
if [[ ! -z "$status" ]]; then
    echo
    echo -e "\033[1;32m" $repoName" \033[2;32m["$branchName"]\033[0;34m"
    echo
    git status | head -2 | tail -1 | awk '{print " " $0}'
    echo
    git status -s
    echo
    echo "--"
fi
