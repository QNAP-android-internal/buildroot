#!/bin/sh

if [ $# != 1 ];then
	echo "ex:eth_qc.sh eth0"
	return 1
fi

if [ -f /tmp/eth_qc_$1.txt ];then
        rm /tmp/eth_qc_$1.txt
fi

ifconfig -a |awk  '{print $1}' |grep $1
if [ $? != 0 ];then
	echo "not found $1"
	return 1
fi

eth=$1
echo "eth=$eth"

while true 
do
	ping -I $eth -c 5 8.8.8.8
	if [ $? == 0 ];then
		echo pass > /tmp/eth_qc_$1.txt
		break
	fi
done
