#!/bin/sh

if [ -f /tmp/usb_qc.txt ];then
	rm /tmp/usb_qc.txt
fi

if [ -f /tmp/usb_tmp.txt ];then
        rm /tmp/usb_tmp.txt
fi

while true
do
	ls /dev/sda* > /tmp/usb_tmp.txt &
	sleep 1
	grep sda /tmp/usb_tmp.txt
	if [ $? == 0 ];then
		echo pass > /tmp/usb_qc.txt
		echo "usb pass"
		break
	else
		echo fail > /tmp/usb_qc.txt
		sleep 2
	fi
done

rm /tmp/usb_tmp.txt

