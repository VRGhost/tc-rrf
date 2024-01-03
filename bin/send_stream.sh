#!/bin/bash -xe

# send local video 

TARGET_DEVICE="${1:-/dev/video0}"
SSH_CLIENT_IP="$(echo "${SSH_CLIENT}" | cut -d ' ' -f 1)"
TARGET_HOST="${2:-${SSH_CLIENT_IP:-127.0.0.1}}"

ffmpeg \
    -f v4l2 -video_size '800x600' \
    -fflags +nobuffer -flags +low_delay \
    -max_delay 0 \
    -i "${TARGET_DEVICE}" \
    -codec h264 \
    -pix_fmt yuv420p \
    -g 1 -r 60 \
    -fflags +nobuffer -flags +low_delay \
    -max_delay 0 \
    -preset fast -tune zerolatency \
    -f mpegts "udp://${TARGET_HOST}:1234"
