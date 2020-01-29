#!/bin/sh

FILE=$1
EXTENSION="${FILE##*.}"
FILENAME="${FILE%.*}"

m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	$1 > ${FILENAME}.conf

