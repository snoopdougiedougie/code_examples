#!/usr/local/bin/bash

tidy="\<meta name=\"generator\" content=\"HTML Tidy, see www.w3.org\" \/\>"

s1="\<style type=\"text\/css\"\>"
s2=":link { color: blue }"
s3=":visited { color: blue }"
s4="\<\/style\>"

# Delete these from the current file

cat $1 | sed /"$tidy"/d | sed /"$s1"/d | sed /"$s2"/d | sed /"$s3"/d | sed /"$s4"/d >> $$.tmp

mv $$.tmp $1
