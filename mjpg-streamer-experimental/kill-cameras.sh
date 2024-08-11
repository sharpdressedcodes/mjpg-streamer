#!/usr/bin/bash

DEVICE0=video0
DEVICE1=video2
PID=`ps aux | grep mjpg | grep /dev/video | awk '{print $2}'`

if [[ ! $PID ]]; then
#    printf '%s\n' "Webcam is not streaming on /dev/$DEVICE0 or /dev/$DEVICE1."
    exit 0
fi

sudo kill -9 $PID

printf '%s\n' "Killed /dev/$DEVICE0 and /dev/$DEVICE1 streams."
