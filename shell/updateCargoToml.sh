#!/usr/bin/bash

# If we have either arg, use them for the replacement text
FROM=${1:-v0.0.21-alpha}
TO=${2:-v0.0.22-alpha}

echo To replace $FROM with $TO
echo press enter
read line

sed -i 's/'${FROM}'/'${TO}'/g' Cargo.toml

echo If the following output does not show $TO
echo rerun this with the appropriate args
echo such as v0.0.17-alpha v0.0.18-alpha

grep alpha Cargo.toml
