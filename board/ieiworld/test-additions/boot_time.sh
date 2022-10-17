#!/bin/sh

if [ ! -f /opt/validation/reboot_test/rebootlog.txt ]; then
	echo "no log file!"
	exit 1
fi

if [ -f /opt/validation/reboot_test/tmp.txt ]; then
	rm /opt/validation/reboot_test/tmp.txt
fi

awk 'NR==1{tmp=$1}NR>1{print $1-tmp;tmp=$1}' /opt/validation/reboot_test/rebootlog.txt > /opt/validation/reboot_test/tmp.txt
sync

if [ $# != 1 ]; then
	echo "ex: boot_time.sh [boottime]"
	exit 1
fi

if [[ ! $1 =~ ^[1-9][0-9]*$ ]]; then
	echo "please enter a number"
	echo "ex: boot_time.sh [boottime]"
	exit 1
fi

checktime=$1
echo "check boottime lower than $checktime s"

errtimes=0
count=0
while read line
do
	if [ $line -gt $checktime  ]; then
		errtimes=$(($errtimes+1))
	fi
	count=$(($count+1)) 
done < /opt/validation/reboot_test/tmp.txt

rate=$(echo "scale=5;100*$errtimes/$count" |bc)
echo "$errtimes / $count"
echo "error rate: $rate%"
