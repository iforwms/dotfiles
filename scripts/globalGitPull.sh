#!/bin/bash

repoPath=$(echo "$1" | sed "s/\/.git//")
repoName=$(basename "$repoPath")
branchName=$(git -C "$repoPath" rev-parse --abbrev-ref HEAD 2>/dev/null)
status=$(git -C "$repoPath" status -s 2>/dev/null)

echo
echo -e "\033[1;35m" "$repoName" "\033[2;35m[" "$branchName" "]\033[0;37m"
echo

# If files are modified, show details
if [[ ! -z "$status" ]]; then
    git -C "$repoPath" status | head -2 | tail -2 | awk '{print " " $0}'
    echo
    git -C "$repoPath" status -s
else
    echo " No local changes."
fi

echo

git -C "$repoPath" pull

echo
echo "--"
