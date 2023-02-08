#!/bin/sh

IMAGE_NAME=$(ls /qc/image/android/)

if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
    IMAGE_SIZE=13958643712
elif [[ "$(cat /proc/device-tree/model | grep "B664")" ]]; then
    IMAGE_SIZE=30064771072
else
    IMAGE_SIZE=13958643712
fi

xzcat /qc/image/android/"$IMAGE_NAME" | (pv -n -s "$IMAGE_SIZE" | dd of=/dev/mmcblk2 bs=1M) 2>&1 | tee /tmp/flash_progress.txt
