#!/bin/bash -xe

## Opens the microscope with crosshair in mplayer


ffplay \
    -max_delay 0 \
    -max_probe_packets 1 \
    -flags +low_delay -fflags +nobuffer \
    -framedrop \
    -analyzeduration 0 \
    -sync ext \
    -probesize 10000 \
    'udp://0.0.0.0:1234'