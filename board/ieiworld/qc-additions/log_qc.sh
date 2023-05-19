#!/bin/sh

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`
case $SOC in
	B643)
		mount_path="//172.56.1.55/ash_log/WAFER-IMX8MP-N/70-00AB643-000-103-RS"
		mac_num=2
		;;
	B664)
		mount_path="//172.56.1.55/ash_log/IASO-W10B-IMX8M-R10-MB/70-00NB664-001-103-RS"
		mac_num=1
		;;
esac
#login=`cat /qc/log_mount_login.txt`
login="user=wigcheng,password=Wwwfq5566"

log_org_path=/qc/log.txt

sn=`hexdump -C /sys/bus/nvmem/devices/imx-ocotp0/nvmem | grep 000000e0 |cut -d"|" -f2 |sed s/\\\.//g`
mac1=`ifconfig |grep eth0 |awk '{print $5}'`
time=`date "+%Y-%m-%d %H:%M:%S"`
time_for_filename=`echo $time |sed s/\ /_/g |sed s/-//g |sed s/://g`
kernel=`uname -r`
if [ $mac_num == 2 ];then
	mac2=`ifconfig |grep eth1 |awk '{print $5}'`
elif [ $mac_num == 1 ];then
	mac2=""
fi

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
	log_name=${sn}_${time_for_filename}_Pass.txt
else
	log_name=${sn}_${time_for_filename}_Fail.txt
fi
log_path=/qc/$log_name

#echo $log_path
cp $log_org_path $log_path ;sync
sed -i -e "s/Serial Number :/Serial Number : $sn/g" $log_path ;sync
sed -i -e "s/eth0 MAC address :/eth0 MAC address : $mac1/g" $log_path ;sync
sed -i -e "s/eth1 MAC address :/eth1 MAC address : $mac2/g" $log_path ;sync
sed -i -e "s/Time :/Time : $time/g" $log_path ;sync
sed -i -e "s/Kernal version :/Kernal version : $kernel/g" $log_path ;sync
cat /tmp/result.txt >> $log_path ;sync
if [ $mac_num == 1 ];then
	sed -i -e '/eth1 MAC address :/d' $log_path ;sync
fi

mount /dev/mmcblk2p1 /mnt
cp $log_path /mnt ;sync
umount /mnt
sleep 1

while true
do
	mount.cifs $mount_path /mnt -o domain="ieinet",$login
	cp $log_path /mnt ;sync
	ls /mnt/$log_name
	if [ $? == 0 ];then
		umount /mnt
		break
	fi
	umount /mnt
	sleep 2
done
