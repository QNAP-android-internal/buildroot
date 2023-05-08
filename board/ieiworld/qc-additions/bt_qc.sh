#!/bin/sh

if [ -f /tmp/bt_qc.txt ];then
        rm /tmp/bt_qc.txt
fi

if [ -f /tmp/btctl_scan.txt ];then
        rm /tmp/btctl_scan.txt
fi

bt_firmware_path=/lib/firmware/BCM4362A2_001.003.006.1045.1053.hcd
baudrate=115200

brcm_patchram_plus  --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate $baudrate --patchram $bt_firmware_path /dev/ttymxc0 &

sleep 10
hciconfig hci0 up

bluetoothctl power on
bluetoothctl agent on
while true
do
	bluetoothctl scan on >/tmp/btctl_scan.txt &
	btctl_scan_pid=`ps |grep "bluetoothctl scan on" |grep -v "grep" |awk '{print $1}'`
	sleep 5
	kill $btctl_scan_pid
	sleep 5
	cat /tmp/btctl_scan.txt |grep "NEW" |awk '{print $3}'>/tmp/bt_mac.txt
	bt_mac=`shuf -n1 /tmp/bt_mac.txt`
	if [[ -z "$bt_mac" ]];then
		sleep 5
		continue
	fi

	bluetoothctl info $bt_mac >/tmp/bt_info.txt
	cat /tmp/bt_info.txt |grep "Device $mac" |grep -v "not available"
	if [ $? == 0 ];then
		echo pass >/tmp/bt_qc.txt
	else
		echo fail >/tmp/bt_qc.txt
	fi
	sleep 10
done
