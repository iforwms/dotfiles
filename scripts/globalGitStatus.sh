#!/bin/bash
repoName=`basename $(pwd)`
branchName=`git rev-parse --abbrev-ref HEAD`
echo "Repo: "$repoName" ["$branchName"]";
#git status | head -2 | tail -1
git status -s
echo "------"
