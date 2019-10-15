#!/bin/sh

IP=134.86.122.49

ssh-keygen -f "/home/mini/.ssh/known_hosts" -R $IP

TPLG_IN=sof-apl-tdf8532-ssp4.tplg
TPLG_OUT=sof-apl-tdf8532.tplg

scp $TPLG_IN root@$IP:/lib/firmware/intel/sof-tplg/$TPLG_OUT

