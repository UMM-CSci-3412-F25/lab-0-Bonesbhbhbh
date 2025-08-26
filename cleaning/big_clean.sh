#!/usr/bin/bash

directory=$1

SCRATCH=`mktemp --directory`

tar zxf $directory --directory $SCRATCH

ls

rm -rf $SCRATCH