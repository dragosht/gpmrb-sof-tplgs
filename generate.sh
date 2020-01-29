#!/bin/sh

m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	$1 > $1.conf

