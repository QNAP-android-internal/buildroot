#!/bin/sh
export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16

/qc/flash_qc.sh &

while true
do	
	if [ -f /tmp/flash_progress.txt ];then
		percentage=`cat /tmp/flash_progress.txt| tail -n1`
		echo $percentage |grep "copied,"
		if [ $? == 0 ];then
			percentage=100
		fi		
	else
		percentage=0
	fi

	echo $percentage | dialog --gauge "Flashing QC image, please wait" 10 70 70 > /dev/tty1
	if [ $percentage -ge 100 ];then	
		break
	fi

	sleep 2
done

sync
echo $percentage | dialog --gauge "Finish! please remove SD card and reboot" 10 70 70 > /dev/tty1
