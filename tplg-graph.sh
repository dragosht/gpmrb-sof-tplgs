#!/bin/sh

m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	--define=GRAPH $1 2> $1.dot

dot $1.dot -Tpng -o $1.png
