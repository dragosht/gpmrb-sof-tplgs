#!/bin/sh


m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	--define=INFO $1 > /dev/null

