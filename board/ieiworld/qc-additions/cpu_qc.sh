#!/bin/sh

while true
do
	if [[ "$(stress-ng --cpu 2 --timeout 5s 2>&1  | grep "successful")" ]];then
		echo "pass" > /tmp/cpu_qc.txt
	else
		echo "fail" > /tmp/cpu_qc.txt
	fi
done
