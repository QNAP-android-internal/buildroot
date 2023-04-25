#!/bin/sh

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`
case $SOC in
	B643)
		mount_path="//172.56.1.55/ash_log/WAFER-IMX8MP-N/70-00AB643-000-103-RS"
		;;
	B664)
		mount_path="//172.56.1.55/ash_log/IASO-W10B-IMX8M-R10-MB/70-00NB664-001-103-RS"
		;;
esac
#login=`cat /qc/log_mount_login.txt`
login="user=wigcheng,password=Wwwfq5566"

log_org_path=/qc/log.txt

sn=`hexdump -C /sys/bus/nvmem/devices/imx-ocotp0/nvmem | grep 000000e0 |cut -d"|" -f2 |sed s/\\\.//g`
mac=`ifconfig |grep eth0 |awk '{print $5}'`
time=`date "+%Y-%m-%d %H:%M:%S"`
time_for_filename=`echo $time |sed s/\ /_/g |sed s/-//g |sed s/://g`
kernel=`uname -r`

while read line
do
	echo $line |grep ":pass"
	if [ $? != 0 ];then
		check_result=false
		break
	else
		check_result=true
	fi
done </tmp/result.txt

if $check_result;then
	log_path=/qc/${sn}_${time_for_filename}_Pass.txt
else
	log_path=/qc/${sn}_${time_for_filename}_Fail.txt
fi

#echo $log_path
cp $log_org_path $log_path ;sync
sed -i -e "s/Serial Number :/Serial Number : $sn/g" $log_path ;sync
sed -i -e "s/eth0 MAC address :/eth0 MAC address : $mac/g" $log_path ;sync
sed -i -e "s/Time :/Time : $time/g" $log_path ;sync
sed -i -e "s/Kernal version :/Kernal version : $kernel/g" $log_path ;sync
cat /tmp/result.txt >> $log_path ;sync

mount /dev/mmcblk2p1 /mnt
cp $log_path /mnt ;sync
umount /mnt
sleep 1

mount.cifs $mount_path /mnt -o domain="ieinet",$login
cp $log_path /mnt ;sync
umount /mnt
