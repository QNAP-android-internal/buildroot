#!/bin/sh

IMAGE_SIZE=375390208
xzcat /sdcard.img.xz | (pv -n -s "$IMAGE_SIZE" | dd of=/dev/mmcblk2 bs=1M) 2>&1 | tee /tmp/flash_progress.txt
