#!/usr/bin/bash

directory=$1

SCRATCH=$(mktemp --directory WOMP-XXXXXX)
here=$(pwd)

tar zxf "$directory" --directory "$SCRATCH" # open directory to temp dir

to_delete=$(grep -lr "DELETE ME" "$SCRATCH")
# echo `basename $to_delete -a`
grep -lrZ "DELETE ME" "$SCRATCH" | xargs -0 rm -f
tree "$SCRATCH"

cd "$SCRATCH"
tar -czf cleaned_"$directory" "$directory"
mv cleaned_"$directory" "$here"
rm -rf $SCRATCH