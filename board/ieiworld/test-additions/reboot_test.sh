#!/bin/sh

if [ ! -f /opt/validation/reboot_test/booton.txt ]; then
	exit 0
fi
sleep 20
while read line
do
	if [ $line == "off" ]; then
		exit 0
	fi
done </opt/validation/reboot_test/booton.txt

date +'%s' >> /opt/validation/reboot_test/rebootlog.txt
sync
reboot
exit 0
