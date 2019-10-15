TPLGS	=	sof-apl-nocodec.tplg \
		sof-apl-tdf8532.tplg

all: $(TPLGS)

%.tplg: %.conf
	alsatplg -v 1 -c $< -o $@

%.conf: %.m4
	m4 -I .. -I ../m4 -I ../common -I ../platform/common  $< > $@

clean:
	rm -f *.tplg *.conf