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
export TSLIB_CALIBFILE=/etc/pointercal

if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
	echo "1563 -51 666480 -58 2535 284402 65536 800 1280 0" > /etc/pointercal
elif [[ "$(cat /proc/device-tree/model | grep "B664")" ]]; then
	echo "5157 13 -624973 22 3318 -1099304 65536 1280 800 0" > /etc/pointercal
fi
ts_test_mt

if [[ "$(echo $?)" == "1" ]];then
    echo "fail" > /tmp/touch_qc.txt
	exit
fi

sh -c 'dialog --colors --title "Touch Test" \
--no-collapse --yesno "Touch Drawing works??" 10 50 \
<> /dev/tty1 >&0 2>&1'

TOUCH_RESULTS="$?"
if [[ "$TOUCH_RESULTS" == '1' ]]; then
    echo "fail" > /tmp/touch_qc.txt

elif [[ "$TOUCH_RESULTS" == '0' ]]; then
    echo "pass" > /tmp/touch_qc.txt
fi

sh -c 'clear <> /dev/tty1 >&0 2>&1'

rm /tmp/input_list
