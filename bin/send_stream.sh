#!/bin/bash -xe

# send local video 

TARGET_DEVICE="${1:-/dev/video0}"
TARGET_HOST="${2:-$(echo "${SSH_CLIENT}" | cut -d ' ' -f 1)}:1234"

ffmpeg \
    -f v4l2 -i "${TARGET_DEVICE}" \
    -c:v libx264 -pix_fmt yuv420p \
    -framerate 5 \
    -preset ultrafast -tune zerolatency \
    -f mpegts "udp://${TARGET_HOST}"
