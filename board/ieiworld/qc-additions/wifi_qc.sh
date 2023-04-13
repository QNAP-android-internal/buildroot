#!/bin/sh

if [ -f /tmp/wifi_qc.txt ];then
	rm /tmp/wifi_qc.txt
fi

if [ -f /tmp/wifiscan_tmp.txt ];then
        rm /tmp/wifiscan_tmp.txt
fi

for i in $(seq 1 10);
do
	if [ -f /tmp/modem_qc.txt ];then
		break
	else
		if [ $i == 10 ];then
			systemctl stop NetworkManager
			sleep 2
		fi
	fi
	sleep 1
done

while true
do
	connmanctl disable wifi 
	connmanctl enable wifi 
	sleep 3

	for i in $(seq 1 10);
	do
		connmanctl scan wifi 
		sleep 2
		connmanctl services > /tmp/wifiscan_tmp.txt
		sync
	done

	cat /tmp/wifiscan_tmp.txt |grep "wifi_"
	if [ $? == 1 ];then
		echo fail > /tmp/wifi_qc.txt
	else
		echo pass > /tmp/wifi_qc.txt
	fi
	sleep 10
done
