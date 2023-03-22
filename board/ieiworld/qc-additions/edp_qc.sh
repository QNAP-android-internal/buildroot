#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

if [ -f /sys/class/i2c-dev/i2c-1/device/1-002d/ ]; then
	echo "lcd bridge existed, starting test"
else
    echo "fail" > /tmp/edp_qc.txt
fi

res_org=`fbset |grep geometry |cut -d ' ' -f 1 --complement`
echo "$res_org" >/tmp/res.txt

fbset -fb /dev/fb0 -g 800 1280 1920 1280 16
fb-test

for i in $(seq 1 100);
do
	echo "$i" > /sys/class/backlight/dp_backlight/brightness
	sleep 0.02
done

sleep 0.5
sh -c 'dialog --colors --title "LCD Test" \
--no-collapse --yesno "RGB, backlight both work?" 10 50 \
<> /dev/tty1 >&0'

LCD_RESULTS="$?"
if [[ "$LCD_RESULTS" == '1' ]]; then
    echo "fail" > /tmp/edp_qc.txt
elif [[ "$LCD_RESULTS" == '0' ]]; then
    echo "pass" > /tmp/edp_qc.txt
fi

dd if=/dev/zero of=/dev/fb0
fbset -fb /dev/fb0 -g $res_org
kill -9 $$
