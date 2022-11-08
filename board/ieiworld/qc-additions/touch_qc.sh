#!/bin/sh

# get input device
cat /proc/bus/input/devices > /tmp/input_list
LINE=$(grep -rn "Touchscreen" /tmp/input_list |  awk -F: '{print $1}')
LINE=`expr $LINE + 4`
EVENT=$(awk "NR==$LINE" /tmp/input_list | awk -F= '{print $2}')
EVENT=${EVENT::-1}

export TSLIB_TSDEVICE=/dev/input/$EVENT
export TSLIB_FBDEVICE=/dev/fb0
export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

ts_test

sh -c 'dialog --colors --title "Touch Test" \
--no-collapse --yesno "Touch Drawing works??" 10 50 \
<> /dev/tty1 >&0 2>&1'

TOUCH_RESULTS="$?"
if [[ "$TOUCH_RESULTS" == '1' ]]; then
    echo "Failed"
elif [[ "$TOUCH_RESULTS" == '0' ]]; then
    echo "Pass"
fi

sh -c 'clear <> /dev/tty1 >&0 2>&1'

rm /tmp/input_list
