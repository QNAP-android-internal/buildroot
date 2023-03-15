#!/bin/sh

if [ -f /tmp/bt_qc.txt ];then
        rm /tmp/bt_qc.txt
fi

if [ -f /tmp/btctl_scan.txt ];then
        rm /tmp/btctl_scan.txt
fi

if [ -f /tmp/bt_ping.txt ];then
        rm /tmp/bt_ping.txt
fi

bt_firmware_path=/lib/firmware/BCM4362A2_001.003.006.1045.1053.hcd
baudrate=115200

brcm_patchram_plus  --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate $baudrate --patchram $bt_firmware_path /dev/ttymxc0 &

sleep 10
hciconfig hci0 up

bluetoothctl power on
bluetoothctl agent on
bluetoothctl scan on >/tmp/btctl_scan.txt &

bt_name="$1"
echo "$bt_name" > /tmp/bt_name.txt

check_bt_info=false
while true
do
	cat /tmp/btctl_scan.txt |grep "$bt_name"
	if [ $? == 0 ];then
		bt_mac=`cat /tmp/btctl_scan.txt |grep "$bt_name" |awk '{print $3}'`
		bluetoothctl info $bt_mac >/tmp/bt_info.txt
		cat /tmp/bt_info.txt |grep "Name: $bt_name"
		if [ $? == 0 ];then
			check_bt_info=true
		fi
	fi	
	if $check_bt_info;then
		#hcitool scan for BT Classic to test l2ping
		hcitool scan > /tmp/bt_hci_scan.txt ;sync
		sleep 2
		cat /tmp/bt_hci_scan.txt |grep "$bt_name"
		if [ $? == 0 ];then
			#classic
			l2ping -c10 -t1 $bt_mac >/tmp/bt_ping.txt ;sync
			cat /tmp/bt_ping.txt |grep "0% loss"
	                if [ $? == 0 ];then
        	                echo pass >/tmp/bt_qc.txt
                	        break
                	fi
		else
			#ble 
			echo pass >/tmp/bt_qc.txt
                        break
		fi
	fi
done

btctl_scan_pid=`ps |grep "bluetoothctl scan on" |grep -v "grep" |awk '{print $1}'`
kill $btctl_scan_pid
