#!/bin/sh
if [ -f /tmp/rtc_qc.txt ];then
	rm /tmp/rtc_qc.txt
fi

echo fail > /tmp/rtc_qc.txt
to_check_driver=false
check_dmesg=false

if [ $# == 1 ];then
	driver=$1
	to_check_driver=true
fi

while true
do
	dmesg |grep "\brtc0\b"
	if [ $? == 0 ];then
		msg_driver=`dmesg |grep "\brtc0\b" |cut -d"]" -f2 |cut -d ' ' -f2`
		check_dmesg=true
	fi	
	if $to_check_driver;then
		if [ $msg_driver == $driver ];then
			echo pass > /tmp/rtc_qc.txt
                        break
		fi
	else
		if $check_dmesg;then
			echo pass > /tmp/rtc_qc.txt
			break
		fi
	fi
done
