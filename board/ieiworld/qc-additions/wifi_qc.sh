#!/bin/sh

if [ -f /tmp/wifi_qc.txt ];then
	rm /tmp/wifi_qc.txt
fi

if [ -f /tmp/wifiscan_tmp.txt ];then
        rm /tmp/wifiscan_tmp.txt
fi

if [ -f /tmp/iperf.txt ];then
        rm /tmp/iperf.txt
fi

if [ -f /tmp/iperfspeed.txt ];then
        rm /tmp/iperfspeed.txt
fi

for i in $(seq 1 10);
do
	if [ -f /tmp/modem_qc.txt ];then
		break
	else
		if [ $i == 10 ];then
			echo fail > /tmp/wifi_qc.txt
			exit
		fi
	fi
	sleep 1
done

connmanctl disable wifi 
connmanctl enable wifi 
wifi_name="$1"
check_connect=false
sleep 3

for i in $(seq 1 10);
do
	connmanctl scan wifi 
	sleep 2
	connmanctl services > /tmp/wifiscan_tmp.txt
	sync
	cat /tmp/wifiscan_tmp.txt |grep "$wifi_name"
	if [ $? == 0 ];then
		wifi_id=`cat /tmp/wifiscan_tmp.txt |grep "$wifi_name" | awk  '{print $NF}'`
        	connmanctl agent on
        	connmanctl connect $wifi_id
	        sleep 2
        fi

	iwconfig |grep "$wifi_name"
	if [ $? == 0 ];then
		check_connect=true
		break
	fi
	sleep 2
done
if ! $check_connect;then
	echo "can not connect wifi $wifi_name"
	exit 1 
fi

iperf_time=60
iperf_sever_ip=$2
check_speed=true
iperf -c $iperf_sever_ip -t$iperf_time -i1 -P8 >/tmp/iperf.txt ;sync

cat /tmp/iperf.txt |grep "\[SUM\] $iperf_time.00"
if [ $? == 0 ];then
	cat /tmp/iperf.txt |grep "sec" | awk  '{print $(NF-1)}' |cut -d "." -f1 >/tmp/iperfspeed.txt
	while read line
	do
		if [ $line -le 0 ];then
			check_speed=false
			break
		fi
	done < /tmp/iperfspeed.txt
	
	if $check_speed;then
		echo pass > /tmp/wifi_qc.txt
	else
		echo fail > /tmp/wifi_qc.txt
	fi
else
	echo fail > /tmp/wifi_qc.txt
fi
