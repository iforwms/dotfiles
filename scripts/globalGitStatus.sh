#!/bin/bash

repoName=`basename $(pwd)`
branchName=`git rev-parse --abbrev-ref HEAD`
status=`git status -s`

# If status, show details
if [[ ! -z "$status" ]]; then
    echo
    echo "Repo: "$repoName" ["$branchName"]"
    echo
    git status | head -2 | tail -1
    echo
    git status -s
    echo
    echo "------"
fi
