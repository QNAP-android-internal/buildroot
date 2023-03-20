#!/bin/sh

check_mac_pattern()
{
	mac=$1
	if [[ $mac =~ ^[0-9a-f]{12}$ ]];then
		return 0
	else
		return 1
	fi	
}

#check hexdump /sys/bus/nvmem/devices/imx-ocotp0/nvmem 00000090 empty
hexdump -C /sys/bus/nvmem/devices/imx-ocotp0/nvmem | grep 00000090 |grep -v "00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00"
if [ $? == 0 ];then
	echo "MAC has burned"
	exit 1
fi

if [ -f /tmp/check_mac.txt ];then
	rm /tmp/check_mac.txt
fi
if [ -f /tmp/mac_toburn.txt ];then
	rm /tmp/mac_toburn.txt
fi
if [ -f /tmp/burn_cmd.txt ];then
	rm /tmp/burn_cmd.txt
fi

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`

case $SOC in
        B643)
                mac_num=2
                ;;
	B664)
		mac_num=1
		;;
esac
echo "$SOC:$mac_num"
input_mac1=false
if [ $mac_num == 2 ];then
	input_mac2=false
else
	input_mac2=true
fi
while true
do
	if ! $input_mac1;then
		dialog --title "MAC1" --inputbox "Enter MAC1:" 10 50 2>/tmp/MAC1.txt <> /dev/tty1 >&0
		if [ $? == 0 ];then
			mac1=`cat /tmp/MAC1.txt | tr '[A-Z]' '[a-z]'`
			check_mac_pattern $mac1
			if [ $? == 0 ];then
				input_mac1=true
				echo "MAC1 : $mac1" >> /tmp/check_mac.txt
			else
				continue
			fi
		else 
			continue
		fi
	fi
	if ! $input_mac2;then
		dialog --title "MAC2" --inputbox "Enter MAC2:" 10 50 2>/tmp/MAC2.txt <> /dev/tty1 >&0
		if [ $? == 0 ];then
			mac2=`cat /tmp/MAC2.txt | tr '[A-Z]' '[a-z]'`
			check_mac_pattern $mac2
                        if [ $? == 0 ];then
                                input_mac2=true
                        	echo "MAC2 : $mac2" >> /tmp/check_mac.txt
			else
                                continue
                        fi
                else
			continue
		fi
	fi
	if $input_mac1 && $input_mac2;then
		check_mac=`cat /tmp/check_mac.txt`
		dialog --title "Check MAC correct or not" \
		--no-collapse --yesno "$check_mac" 10 50 \
		<> /dev/tty1 >&0
		if [ $? == 0 ];then
			break
		else
			rm /tmp/check_mac.txt
			input_mac1=false
			if [ $mac_num == 2 ];then
			        input_mac2=false
			fi
		fi
	fi
done

for i in $(seq 0 $mac_num);
do
	if [ $i == 0 ];then
		continue
	fi
	eval mac$i=`cat /tmp/MAC$i.txt | tr '[A-Z]' '[a-z]'`	
	x=0
	for j in $(seq 1 6);
	do
		eval mac${i}_${j}=\${mac$i:$x:2}
		x=$(($x+2))
	done
	eval echo "\$mac${i}_6:\$mac${i}_5:\$mac${i}_4:\$mac${i}_3:\$mac${i}_2:\$mac${i}_1"
done

mac_toburn1="\x$mac1_6\x$mac1_5\x$mac1_4\x$mac1_3"
if [ $mac_num == 1 ];then
	mac_toburn2="\x$mac1_2\x$mac1_1\x00\x00"
	mac_toburn3="\x00\x00\x00\x00"
elif [ $mac_num == 2 ];then
	mac_toburn2="\x$mac1_2\x$mac1_1\x$mac2_6\x$mac2_5"
	mac_toburn3="\x$mac2_4\x$mac2_3\x$mac2_2\x$mac2_1"
fi

echo "MAC : $mac_toburn1 $mac_toburn2 $mac_toburn3"
echo $mac_toburn1 >>/tmp/mac_toburn.txt
echo $mac_toburn2 >>/tmp/mac_toburn.txt
echo $mac_toburn3 >>/tmp/mac_toburn.txt

echo "printf '$mac_toburn1'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x24))" >>/tmp/burn_cmd.txt
echo "printf '$mac_toburn2'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x25))" >>/tmp/burn_cmd.txt
echo "printf '$mac_toburn3'|dd conv=notrunc of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 seek=$((0x26))" >>/tmp/burn_cmd.txt

cat /tmp/burn_cmd.txt |sh
sync
