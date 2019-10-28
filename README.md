Simple ALSA topology playground for Gordon Peak MRB with SOF

The purpose of this repo is messing around with SOF on the gp-mrb board and try
different widgets and topology configurations. The sof topology framework
currently includes the following predefined pipelines for playback:

- pipe-passthrough-playback.m4


      PCM --> B0 --> DAI

- pipe-volume-playback.m4


      PCM --> B0 --> Volume 0 --> B1 --> DAI

- pipe-eq-fir-volume-playback.m4


      PCM --> B0 --> EQ FIR 0 --> B1 --> Volume 0 --> B2 --> DAI

- pipe-eq-iir-volume-playback.m4


      PCM --> B0 --> EQ IIR 0 --> B1 --> Volume 0 --> B2 --> DAI

- pipe-eq-volume-playback.m4


      PCM --> B0 --> EQ IIR 0 --> B1  --> EQ FIR 0 --> B2 --> Volume 0 --> B3 --> DAI

- pipe-src-playback.m4


      PCM --> B0 --> SRC 0 --> B1 Volume 0 --> B2 --> DAI

- pipe-pcm-media.m4


      PCM --B0--> volume(0P) --B1--> SRC -- B2 --> EndPoint Pipeline

- pipe-tone.m4


      Tone --B0--> volume --B1--> Endpoint Pipeline

- pipe-low-latency-playback.m4


      PCM --B0--> volume(0P) --B1--+
                                   |--ll mixer(M) --B2--> volume(LL) ---B3-->  DAI
                  pipeline n+1 >---+
                                   |
                  pipeline n+2 >---+
                                   |
                  pipeline n+3 >---+  .....etc....more pipes can be mixed here

And some others.
