#!/bin/sh

if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
        IMAGE_SIZE=13958643712
        FOLDER="b643"
elif [[ "$(cat /proc/device-tree/model | grep "B664")" ]]; then
        IMAGE_SIZE=30064771072
        FOLDER="b664"
else
        IMAGE_SIZE=13958643712
        FOLDER="b643"
fi

IMAGE_NAME=$(ls /mnt/"$FOLDER")
xzcat /mnt/"$FOLDER"/"$IMAGE_NAME" | (pv -n -s "$IMAGE_SIZE" | dd of=/dev/mmcblk2 bs=1M) 2>&1 | tee /tmp/flash_progress.txt
