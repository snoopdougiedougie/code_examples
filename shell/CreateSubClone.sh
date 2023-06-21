#!/usr/bin/bash

echo This script takes three args
echo $1 is the name of the sub-directory in our GitHub repo to clone.
echo $2 is the name of the new GitHub repo to create.
echo $3 is your GitHub user name.

echo "If you don't have these set, AND the GitHub CLI installed, hit Ctrl-C to interrupt this script."

read $line

Subdir=$1
Newrepo=$2
Username=$3

#echo "You must create the repository $Newrepo from your https://github.com/${Username} page."
#echo "If you haven't done so already, hit Ctrl-C to interrupt this script."

#read $line

# Clones a sub-directory in our GitHub repo () locally to ~/src/aws-doc-sdk-examples/$Subdir,
# then creates a new repo from the local directory $Newrepo.

# So if you call it with gov2 MyGoV2Repo GITHUB-USERNAME
# It creates the directory ~/src/MyGoV2Repo
# with files from aws-doc-sdk-examples/gov2,
# and uploads them to the repo MyGoV2Repo,
# all under your GitHub credentials.

# GitRoot is where we clone all of our GitHub repos.
GitRoot=~/src
Repo=aws-doc-sdk-examples

# If source directory does not exist, create it.
if [ ! -d "$GitRoot" ]; then
  mkdir $GitRoot
fi

# Bail if we already have a clone of our repo.
if [ -d "$GitRoot/$Repo" ]; then
    echo "$GitRoot/$Repo already exists. Bye!"
    exit
fi

echo Creating $GitRoot/$Repo
pushd $GitRoot
mkdir $Repo
cd $Repo

git init
git config core.sparsecheckout true
echo $Subdir >> .git/info/sparse-checkout
git remote add -f origin https://github.com/awsdocs/${Repo}
git pull origin master

echo Moving to $GitRoot/$Newrepo
mkdir $GitRoot/$Newrepo
cd $GitRoot/$Newrepo

#echo Creating the repo under your account
#gh repo create
echo Creating the repo ${Newrepo} under the awsdocs org
gh repo create awsdocs/${Newrepo}

echo Creating repo
git init

echo Copying files from $GitRoot/$Repo/$Subdir to $GitRoot/$Newrepo
cp -r $GitRoot/$Repo/$Subdir $GitRoot/$Newrepo

#cd $GitRoot/$Newrepo

rm .git/description
echo $Newrepo > .git/description
git add .
git commit -m "Initial batch of files"
git branch -M main

git remote add origin https://github.com/awsdocs/${Newrepo}.git

git push -u origin main

popd
echo "Created new repo $Newrepo"
