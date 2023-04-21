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

dialog --infobox "Loading... Please wait" 10 30 > /dev/tty1

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
		cp /tmp/tmp.json $config_path
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

dialog --infobox "Loading... Please wait" 10 30 > /dev/tty1

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
		
		station="IEI_Factory_Test"
		echo $dialog_display >/tmp/display_debug.txt
		dialog_cmd="dialog --colors --title \"$station\" --msgbox \"$dialog_display\" 50 50 <> /dev/tty1 >&0 &"
		#dialog_cmd="dialog --colors --title "IEI_Factory_Test" --mixedgauge \n\n\n\n\n\Z5Burning_Android 50 50 $percentage $dialog_display"
		echo $dialog_cmd >/tmp/dialog_debug.txt
		echo $dialog_cmd |sh
		
		sleep 4
		msgbox_pid=`ps |grep msgbox |grep -v grep |awk '{print $1}'`
		if [[ -n "$msgbox_pid" ]];then
			kill $msgbox_pid
			i=0
			continue
		else
			kill $msgbox_pid
			dialog --title "upload test log" --yesno "Sure you want to upload test log?" 20 50 <> /dev/tty1 >&0
			if [ $? == 0 ];then
				#/qc/log_qc.sh
				break
			else
				i=0
				continue
			fi
		fi

		times=$(($times+1))
		#if [ $times -gt 150 ];then
		i=0
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
