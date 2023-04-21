#!/bin/sh

check_sn_pattern()
{	
	sn=$1
	SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`
	pattern=${SOC}V
	if [[ $sn =~ ${pattern}[0-9]{3}-[0-9]{6}$ ]];then
		return 0
	else
		return 1
	fi	
}

if [ -f /tmp/burn_sn_cmd.txt ];then
	rm /tmp/burn_sn_cmd.txt
fi

hexdump -C /sys/bus/nvmem/devices/imx-ocotp0/nvmem | grep 000000e0 |grep -v "00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00"
if [ $? == 0 ];then
	echo "SN has burned"
	exit 1
fi

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

input_sn=false
while true
do
	if ! $input_sn;then
		dialog --title "SN" --inputbox "Enter SN:" 10 50 2>/tmp/SN.txt <> /dev/tty1 >&0
		if [ $? == 0 ];then
			sn=`cat /tmp/SN.txt`
			check_sn_pattern $sn
			if [ $? == 0 ];then
				input_sn=true
			else
				continue
			fi
		else
			continue
		fi
	fi
	if $input_sn;then
		dialog --title "Check SN correct or not" \
		--no-collapse --yesno "SN : $sn" 10 50 \
		<> /dev/tty1 >&0
		if [ $? == 0 ];then
			break
		else
			input_sn=false
		fi
	fi	
done

sn_hex=`echo $sn | od -t x1`
sn_toburn1=`echo $sn_hex |awk '{print $2,$3,$4,$5}'|sed -e 's# #\\\x#g'`
sn_toburn2=`echo $sn_hex |awk '{print $6,$7,$8,$9}'|sed -e 's# #\\\x#g'`
sn_toburn3=`echo $sn_hex |awk '{print $10,$11,$12,$13}'|sed -e 's# #\\\x#g'`
sn_toburn4=`echo $sn_hex |awk '{print $14,$15,$16}'|sed -e 's# #\\\x#g'`

echo "printf '\x$sn_toburn1'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x38))" >>/tmp/burn_sn_cmd.txt
echo "printf '\x$sn_toburn2'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x39))" >>/tmp/burn_sn_cmd.txt
echo "printf '\x$sn_toburn3'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x3a))" >>/tmp/burn_sn_cmd.txt
echo "printf '\x$sn_toburn4\x00'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x3b))" >>/tmp/burn_sn_cmd.txt

sync
cat /tmp/burn_sn_cmd.txt |sh
sync
