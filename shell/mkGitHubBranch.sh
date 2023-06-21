#!/usr/bin/bash

if [ "$1" == "" ]
then
    echo "You must supply a branch name"
    exit 0
fi

if [ "$2" == "" ]
then
    echo "You must supply a main branch name"
    exit 0
fi

git checkout $2
git pull
git checkout -b $1
git push origin $1
git branch --set-upstream-to=origin/$1 $1

git status
