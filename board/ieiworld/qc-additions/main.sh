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

config_path="/mnt/configs/$config"

if [ -f /tmp/result.txt ];then
	rm /tmp/result.txt
fi

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
	exec=`eval jq '.[$i].exec' $config_path |sed s/\"//g`
	checkauto=`eval jq '.[$i].auto' $config_path |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`

	if [ $name == "END" ];then
		break
	else
		if $teston;then
			if $checkauto;then
				#echo ${exec}
				$exec &
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
	exec=`eval jq '.[$i].exec' $config_path |sed s/\"//g`
	checkauto=`eval jq '.[$i].auto' $config_path |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path |sed s/\"//g`

	if [ $name == "END" ];then
		break
	else
		if $teston;then
			if ! $checkauto;then
				$exec
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

		echo $dialog_display >/display_debug.txt
		#dialog_cmd="dialog --colors --title 'IEI_Factory_Test' --infobox $dialog_display 50 50 "
		dialog_cmd="dialog --colors --title "IEI_Factory_Test" --mixedgauge \n\n\n\n\n\Z5Burning_Android 50 50 $percentage $dialog_display"
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
			echo -n "\Z2\ZB$name 2 " >>/tmp/dialog_display.txt
		else
			echo -n "\Z1\ZB$name 1 " >>/tmp/dialog_display.txt
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
	echo "all pass" >/tmp/pass.txt
#	/qc/burn_mac.sh
fi

sh -c 'dialog --colors --title "Burning Android Complete" \
--no-collapse --yesno "Reboot or not?" 10 50 \
<> /dev/tty1 >&0'

if [ $? == 0 ];then
	reboot
fi
