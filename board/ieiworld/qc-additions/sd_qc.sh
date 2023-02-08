#!/bin/sh

if [ -f /tmp/sd_qc_$1.txt ];then
        rm /tmp/sd_qc_$1.txt
fi

if [ -f /tmp/sd_qc.txt ];then
        rm /tmp/sd_qc.txt
fi

while true
do
        ls /dev/mmcblk* > /tmp/sd_tmp.txt &
        sleep 1
        grep $1 /tmp/sd_tmp.txt
        if [ $? == 0 ];then
                echo pass > /tmp/sd_qc_$1.txt
                echo "usd pass"
                break
        else
                echo fail > /tmp/sd_qc_$1.txt
                sleep 2
        fi
done

rm /tmp/sd_tmp.txt
