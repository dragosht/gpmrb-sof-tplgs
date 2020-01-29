#!/bin/sh

FILE=$1
EXTENSION="${FILE##*.}"
FILENAME="${FILE%.*}"

alsatplg -v 1 -c $1 -o ${FILENAME}.tplg

