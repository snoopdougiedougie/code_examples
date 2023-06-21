#!/usr/bin/bash

branch=`git rev-parse --abbrev-ref HEAD`

echo To update $branch from master hit Enter
echo otherwise hit Ctrl-C to quit
echo 

read line

echo 
echo Updating master branch
echo 
git checkout master
git pull
echo 

git checkout $branch
git fetch --all -p
git fetch origin
git rebase origin\/master
git clean -fdX

git status

echo 
echo If you see:
echo
echo Your branch and origin/$branch have diverged
echo
echo run git status and follow the results
echo 
echo Done
echo -n
