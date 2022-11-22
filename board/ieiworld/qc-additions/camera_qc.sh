#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/


if [ $(ls $1) ]; then
    echo "ov5640 driver existed, starting test"
else
    echo "fail" > /tmp/camera_qc.txt
fi

v4l2-ctl --device $1 --set-fmt-video=width=640,height=480,pixelformat=YUYV
v4l2-ctl --device $1 --stream-mmap --stream-skip=1 --stream-to=frame.raw --stream-count=10

dd if=frame.raw conv=swab | convert -sampling-factor 4:2:2 -size 640x480 -depth 8 uyvy:- /tmp/camera-test.png

fbv /tmp/camera-test.png &

sleep 5

sh -c 'dialog --colors --title "Camera Test" \
--no-collapse --yesno "See the capture image??" 10 50 \
<> /dev/tty1 >&0'

CAMERA_RESULTS="$?"
if [[ "$CAMERA_RESULTS" == '1' ]]; then
    echo "fail" > /tmp/camera_qc.txt
elif [[ "$CAMERA_RESULTS" == '0' ]]; then
    echo "pass" > /tmp/camera_qc.txt
fi

dd if=/dev/zero of=/dev/fb0


