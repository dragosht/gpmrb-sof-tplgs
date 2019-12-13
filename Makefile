TPLGS	=	sof-apl-nocodec.tplg \
		sof-apl-nocodec-ssp5.tplg \
		sof-apl-nocodec-ssp5-tone.tplg \
		sof-apl-tdf8532.tplg \
		sof-apl-tdf8532-ssp4.tplg \
		sof-apl-tdf8532-mix.tplg \
		sof-apl-tdf8532-eq.tplg \
		sof-apl-tdf8532-fir.tplg \
		sof-apl-tdf8532-iir.tplg \
		sof-apl-tdf8532-demux.tplg \
		sof-apl-tdf8532-asrc.tplg \
		sof-byt-ssp2.tplg

all: $(TPLGS)

%.tplg: %.conf
	alsatplg -v 1 -c $< -o $@

%.conf: %.m4
	m4 -I .. -I ../m4 -I ../common -I ../platform/common  $< > $@

clean:
	rm -f *.tplg *.dot *.png
