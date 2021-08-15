#!/bin/bash -xe

## Opens the microscope with crosshair in mplayer



DEVICE=/dev/video0
VIDEO_W=640
VIDEO_H=480


RECTANGLES="
        rectangle=10:10:$(expr "${VIDEO_W}" / 2 - 5):$(expr "${VIDEO_H}" / 2 - 5),
        rectangle=40:40:$(expr "${VIDEO_W}" / 2 - 20):$(expr "${VIDEO_H}" / 2 - 20),
        rectangle=140:140:$(expr "${VIDEO_W}" / 2 - 140/2):$(expr "${VIDEO_H}" / 2 - 140/2),
        rectangle=-1:2:0:$(expr "${VIDEO_H}" / 2),
        rectangle=2:-1:$(expr "${VIDEO_W}" / 2):0
"


mplayer \
    tv:// -tv "driver=v4l2:device=${DEVICE}:width=${VIDEO_W}:height=${VIDEO_H}:fps=10:outfmt=yuy2" \
    -vf "$(echo ${RECTANGLES} | sed "s/\s*//g")"

#rectangle=2:-1:$(expr "${VIDEO_H}" / 3):-1