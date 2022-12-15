#!/bin/sh

if [ -f /tmp/nor_qc.txt ];then
        rm /tmp/nor_qc.txt
fi

while true
do
	cat /proc/mtd
	if [ $? == 0 ];then
                echo pass > /tmp/nor_qc.txt
                echo "nor pass"
                break
        else
                echo fail > /tmp/nor_qc.txt
                sleep 2
        fi	
done
