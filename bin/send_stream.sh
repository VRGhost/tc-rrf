#!/bin/bash -xe

# send local video 

TARGET_DEVICE="${1:-/dev/video0}"
TARGET_IP="${2:-$(echo "${SSH_CLIENT}" | cut -d ' ' -f 1)}"

ffmpeg \
    -f v4l2 -i "${TARGET_DEVICE}" \
    -c:v libx264 -pix_fmt yuv420p \
    -framerate 15 -g 30 -b:v 500k \
    c:a aac -b:a 128k -ar 44100 -ac 2 \
    -preset ultrafast -tune zerolatency \
    -f mpegts "udp://${TARGET_IP}:1234"