#!/usr/bin/bash

directory=$1

SCRATCH=$(mktemp --directory)
base=$(basename "$directory" .tgz)
here=$(pwd)

tar zxf "$directory" --directory "$SCRATCH" # open directory to temp dir

grep -lrZ "DELETE ME" "$SCRATCH" | xargs -0 rm -f

cd "$SCRATCH" || return
tar -czf "$here/cleaned_$directory" "$base"

cd "$here" || return
rm -rf "$SCRATCH"