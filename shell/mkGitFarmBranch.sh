#!/usr/bin/bash

if [ "$1" == "" ]
then
    echo "You must a branch name"
    exit 0
fi

git checkout mainline
git pull
git checkout -b $1
git push origin $1
git branch --set-upstream-to=origin/$1 $1

git status
