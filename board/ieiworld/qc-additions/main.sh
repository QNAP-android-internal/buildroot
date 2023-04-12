#!/bin/sh
export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`

case $SOC in
        B643)
                config="B643_qc_config.json"
                ;;
	B664)
		config="B664_qc_config.json"
		;;
esac

config_path="/qc/configs/$config"

if [ -f /tmp/result.txt ];then
	rm /tmp/result.txt
fi
if [ -f /tmp/testitem.txt ];then
	rm /tmp/testitem.txt
fi

#dialog checklist for choosing test items
i=0
while true
do
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	if [ $name == "END" ];then
		break
	else
		echo "$name \"\" on " >>/tmp/testitem.txt
	fi
	i=$(($i+1))
done

testitem=`cat /tmp/testitem.txt`
dialog_cmd="dialog --separate-output --title \"Test items\" --checklist \"Choose test items\" 80 60 2 $testitem  2>/tmp/chosen_items.txt <> /dev/tty1 >&0"
echo $dialog_cmd |sh

i=0
while true
do
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	if [ $name == "END" ];then
		break
	else
		matched=false
		while read line
		do
			if [ $line == $name ];then
				matched=true
				break
			fi
		done < /tmp/chosen_items.txt
		if $matched;then
			jq_cmd="jq '.[$i].teston = \"true\"' $config_path >/tmp/tmp.json"
		else
			jq_cmd="jq '.[$i].teston = \"false\"' $config_path >/tmp/tmp.json"
		fi
		echo $jq_cmd |sh
		mv /tmp/tmp.json $config_path
	fi
	i=$(($i+1))
done

#set resolution 1920*1080 when there is hdmi on the board(B643) and without panel
check_hdmi=false
check_dsi=false
i=0
while true
do
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`
	if [ $name == "END" ];then
		break
	else
		if [ $name == "HDMI" ] && [ $teston == "true" ];then
			check_hdmi=true
		fi
		if [ $name == "DSI" ] && [ $teston == "true" ];then
        	        check_dsi=true
        	fi
	fi
	i=$(($i+1))
done

if $check_hdmi;then
	if ! $check_dsi;then
		echo "1920*1080"
		fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16	
	fi
fi

i=0
while true
do	
	#collect and integrate status files defined in config file;
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	exec=`eval jq '.[$i].exec' $config_path |sed s/\"//g |sed s/\'/\"/g`
	checkauto=`eval jq '.[$i].auto' $config_path |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`

	if [ $name == "END" ];then
		break
	else
		if $teston;then
			if $checkauto;then
				#echo ${exec}
				echo $exec |sh &
				echo $name: >>/tmp/result.txt
			fi
		fi
	fi
	
	i=$(($i+1))		
done

i=0
while true
do
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	exec=`eval jq '.[$i].exec' $config_path |sed s/\"//g |sed s/\'/\"/g`
	checkauto=`eval jq '.[$i].auto' $config_path |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`

	if [ $name == "END" ];then
		break
	else
		if $teston;then
			if ! $checkauto;then
				echo $exec |sh
				echo $name: >>/tmp/result.txt
			fi
		fi
	fi
	i=$(($i+1))
done

times=0
i=0
while true
do
	name=`eval jq '.[$i].names' $config_path |sed s/\"//g`
	statusFile=`eval jq '.[$i].statusFile' $config_path |sed s/\"//g`	
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`
	
	if [ $name == "END" ];then
		#dialog output
		dialog_display=`cat /tmp/dialog_display.txt`
		rm /tmp/dialog_display.txt
		
		if [ -f /tmp/flash_progress.txt ];then
			percentage=`cat /tmp/flash_progress.txt| tail -n1`
			echo $percentage |grep "copied,"
			if [ $? == 0 ];then
				percentage=100
			fi		
		else
			percentage=0
		fi
		
		station="IEI_Factory_Test"
		#echo $dialog_display >/display_debug.txt
		dialog_cmd="dialog --colors --title '$station' --infobox $dialog_display 50 50 "
		#dialog_cmd="dialog --colors --title "IEI_Factory_Test" --mixedgauge \n\n\n\n\n\Z5Burning_Android 50 50 $percentage $dialog_display"
		echo $dialog_cmd >/dialog_debug.txt
		$dialog_cmd >/dev/tty1
		i=0
		times=$(($times+1))
		sleep 2
		#if [ $times -gt 150 ];then
		if [ $percentage -ge 100 ];then	
			break
		fi
		continue
	fi
	if $teston;then
		status=`cat $statusFile`
		eval sed -i 's/^$name:.*/$name:$status/g' /tmp/result.txt
		if [ $status == "pass" ];then
			echo -n "\Z0\ZB$name:\Z2PASS\n" >>/tmp/dialog_display.txt
		else
			echo -n "\Z0\ZB$name:\Z1Failed\n" >>/tmp/dialog_display.txt
		fi
	fi
	i=$(($i+1))	
done

sync
sleep 3

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
	reboot_msg="Reboot or not?"
	sh -c 'dialog --title "Burning Android Complete" \
	--no-collapse --yesno "Burn MAC or not?" 10 50 \
	<> /dev/tty1 >&0'
	
	if [ $? == 0 ];then
		/qc/burn_mac.sh
        fi
else
	reboot_msg="Some test items fail ,can't brun MAC \n\nreboot or not?"
fi

dialog_reboot="dialog --title \"REBOOT\" --no-collapse --yesno \"$reboot_msg\" 10 50 <> /dev/tty1 >&0"
echo $dialog_reboot |sh
if [ $? == 0 ];then
	reboot
fi

