#!/bin/sh

CNT=0
CNT_MAX=15

while true
do
	MODULE=$(mmcli -m 0 | grep "h/w revision" | awk -F: '{print $2}')
	if [[ "$MODULE" == " EM7455" ]];then
		break
	else
		if [[ "$CNT" == "$CNT_MAX" ]];then
			echo "fail" > /tmp/modem_qc.txt
			systemctl stop NetworkManager
			exit
		fi
	fi

	CNT=$((CNT+1))
	sleep 1
done

if [[ "$(mmcli -m 0 | grep "sim-missing")" ]];then
	echo "fail" > /tmp/modem_qc.txt
else

	if [[ $(mmcli -m 0 | grep own | awk -F: '{print $2}' | grep "+8") ]];then
		# make sure phone number is +886/+86
		echo "pass" > /tmp/modem_qc.txt
	else
		echo "fail" > /tmp/modem_qc.txt
	fi
fi

systemctl stop NetworkManager
