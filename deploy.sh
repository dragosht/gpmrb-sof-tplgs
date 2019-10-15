#!/bin/sh

IP=134.86.122.49

ssh-keygen -f "/home/dtarcatu/.ssh/known_hosts" -R $IP

scp sof-apl-tdf8532.tplg root@$IP:/lib/firmware/intel/sof-tplg/
scp sof-apl-nocodec.tplg root@$IP:/lib/firmware/intel/sof-tplg/

