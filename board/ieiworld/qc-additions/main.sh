#!/bin/sh
export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

config_path="/qc/configs"

if [ -f /tmp/result.txt ];then
	rm /tmp/result.txt
fi

i=0
while true
do	
	#collect and integrate status files defined in config file;
	name=`eval jq '.[$i].names' $config_path/config.json |sed s/\"//g`
	exec=`eval jq '.[$i].exec' $config_path/config.json |sed s/\"//g`
	checkauto=`eval jq '.[$i].auto' $config_path/config.json |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path/config.json |sed s/\"//g`

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
	name=`eval jq '.[$i].names' $config_path/config.json |sed s/\"//g`
	exec=`eval jq '.[$i].exec' $config_path/config.json |sed s/\"//g`
	checkauto=`eval jq '.[$i].auto' $config_path/config.json |sed s/\"//g`
	teston=`eval jq '.[$i].teston' $config_path/config.json |sed s/\"//g`

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

i=0
while true
do
	name=`eval jq '.[$i].names' $config_path/config.json |sed s/\"//g`
	statusFile=`eval jq '.[$i].statusFile' $config_path/config.json |sed s/\"//g`	
	
	if [ $name == "END" ];then
		#dialog output
		dialog_display=`cat /tmp/dialog_display.txt`
		rm /tmp/dialog_display.txt
		
		#echo $dialog_display
		dialog_cmd="dialog --colors --title 'IEI_Factory_Test' --infobox $dialog_display 50 50 "

		#echo $dialog_cmd
		$dialog_cmd >/dev/tty1
		#break
		i=0
		sleep 2
		continue
	fi
	status=`cat $statusFile`
	eval sed -i 's/^$name:.*/$name:$status/g' /tmp/result.txt
	if [ $status == "pass" ];then
		echo -n "\Z0\ZB$name:\Z2PASS\n" >>/tmp/dialog_display.txt
	else
		echo -n "\Z0\ZB$name:\Z1Failed\n" >>/tmp/dialog_display.txt
	fi
	i=$(($i+1))	
done
