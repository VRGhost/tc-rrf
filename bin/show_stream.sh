#!/bin/bash -xe

## Opens the microscope with crosshair in mplayer


ffplay \
    -max_probe_packets 1 \
    -flags +low_delay -fflags +nobuffer \
    -max_delay 0 \
    -framedrop \
    -analyzeduration 0 \
    -sync ext \
    -probesize 32 \
    'udp://0.0.0.0:1234'
    
