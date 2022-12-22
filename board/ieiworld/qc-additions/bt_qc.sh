#!/bin/sh

if [ -f /tmp/bt_qc.txt ];then
        rm /tmp/bt_qc.txt
fi

if [ -f /tmp/bt_scan.txt ];then
        rm /tmp/bt_scan.txt
fi

if [ -f /tmp/bt_ping.txt ];then
        rm /tmp/bt_ping.txt
fi

bt_firmware_path=/lib/firmware/BCM4362A2_001.003.006.1045.1053.hcd
baudrate=115200

echo 0 > /sys/class/rfkill/rfkill0/state
echo 1 > /sys/class/rfkill/rfkill0/state
brcm_patchram_plus  --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate $baudrate --patchram $bt_firmware_path /dev/ttymxc0 &

sleep 10

rfkill unblock 0

hciconfig hci0 up

while true
do
	hcitool scan > /tmp/bt_scan.txt ;sync
	cat /tmp/bt_scan.txt |grep "$1"
	if [ $? == 0 ];then
		bt_mac=`cat /tmp/bt_scan.txt |grep "$1" |awk  '{print $1}'`
		l2ping -c10 -t1 $bt_mac >/tmp/bt_ping.txt
		cat /tmp/bt_ping.txt |grep "0% loss"
		if [ $? == 0 ];then
			echo pass >/tmp/bt_qc.txt
			break
		fi			
	fi
done
