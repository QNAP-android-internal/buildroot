#!/bin/sh

if [ -f /tmp/hdmi_qc.txt ];then
	rm /tmp/hdmi_qc.txt
fi
if [ -f /tmp/edid_tmp ];then
        rm /tmp/edid_tmp
fi

res_org=`fbset |grep geometry |cut -d ' ' -f 1 --complement`
echo "$res_org" >/tmp/res.txt

hexdump /sys/devices/platform/display-subsystem/drm/card1/card1-HDMI-A-1/edid >/tmp/edid_tmp
edid_size=`du /tmp/edid_tmp | awk '{print $1}'`
if [ $edid_size == 0 ];then
	echo fail >/tmp/hdmi_qc.txt
	cat /tmp/hdmi_qc.txt
	return 1
fi

fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16
fb-test
sleep 5

sh -c 'dialog --colors --title "HDMI Test" \
--no-collapse --yesno "Is HDMI RGB work?" 10 50 \
<> /dev/tty1 >&0'

if [ $? == 0 ];then
	echo pass >/tmp/hdmi_qc.txt	
elif [ $? == 1 ];then
	echo fail >/tmp/hdmi_qc.txt	
fi
cat /tmp/hdmi_qc.txt

dd if=/dev/zero of=/dev/fb0
fbset -fb /dev/fb0 -g $res_org

kill -9 $$