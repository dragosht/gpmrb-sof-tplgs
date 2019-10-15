#!/bin/sh

#m4 -I .. -I ../m4 -I ../common -I ../platform/common \
#	--define=INFO sof-apl-tdf8532.m4 > /dev/null

m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	--define=GRAPH sof-apl-tdf8532.m4 2> test.dot

#m4 -I .. -I ../m4 -I ../common -I ../platform/common \
#	--define=GRAPH sof-apl-nocodec.m4 2> test.dot

dot test.dot -Tpng -o tplg.png
