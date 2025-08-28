#!/usr/bin/bash

directory=$1 # usr inputs a directory to clean
SCRATCH=$(mktemp --directory) # make an empty temp directory
base=$(basename "$directory" .tgz) # save the name of the directory you are working with
here=$(pwd) # save working directory

tar zxf "$directory" --directory "$SCRATCH" # open directory and put it into the new temp dir

grep -lrZ "DELETE ME" "$SCRATCH" | xargs -0 rm -f # make list of files pending deletion then delete them

cd "$SCRATCH" || return # enter the temp directory
tar -czf "$here/cleaned_$directory" "$base" # create a directory (a level up) and put contents of base directory into it

cd "$here" || return # go back to the start working directory
rm -rf "$SCRATCH" # delete temp directory