#!/bin/sh

m4 -I .. -I ../m4 -I ../common -I ../platform/common \
	sof-apl-tdf8532.m4 > sof-apl-tdf8532.conf

#m4 -I .. -I ../m4 -I ../common -I ../platform/common \
#	sof-apl-nocodec.m4 > sof-apl-nocodec.conf

