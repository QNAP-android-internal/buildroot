#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

if [[ $(ls /dev/sda*) ]];then
        echo "GET USB INSTALLER"
        mount /dev/sda1 /mnt
else
        echo "NO USB INSTALLER"
        sh -c 'dialog --colors --title "ANDROID FLASHING" \
        --no-collapse --msgbox "NO DETECT USB INSTALLER\nPlease reboot and try again" 10 50 \
        <> /dev/tty1 >&0 2>&1'
        exit
fi


if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
        IMAGE_SIZE=13958643712
        FOLDER="b643"
elif [[ "$(cat /proc/device-tree/model | grep "B664")" ]]; then
        IMAGE_SIZE=30064771072
        FOLDER="b664"
else
        IMAGE_SIZE=13958643712
        FOLDER="b643"
fi

IMAGE_NAME=$(ls /mnt/"$FOLDER")
(xzcat /mnt/"$FOLDER"/"$IMAGE_NAME" | (pv -n -s "$IMAGE_SIZE" | dd of=/dev/mmcblk2 bs=1M) 2>&1 | tee /tmp/flash_progress.txt)&

sleep 1

while true
do
        if [ -f /tmp/flash_progress.txt ];then
                percentage=`cat /tmp/flash_progress.txt| tail -n1`
                echo $percentage |grep "copied,"
                if [ $? == 0 ];then
                        percentage=100
                fi
        else
                percentage=0
        fi

        echo $percentage | dialog --gauge "Flashing Android image, please wait" 10 70 70 > /dev/tty1
        if [ $percentage -ge 100 ];then
                break
        fi

        sleep 3
done

sync
echo $percentage | dialog --gauge "Finish! please reboot into Android OS" 10 70 70 > /dev/tty1
umount /mnt
