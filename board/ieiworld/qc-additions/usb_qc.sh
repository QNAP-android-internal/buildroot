#!/bin/sh

if [ -f /tmp/usb_qc.txt ];then
	rm /tmp/usb_qc.txt
fi

while true
do
	USB_CNT=0

	if [[ "$(lsusb -t | grep "Port 3")" ]]; then
		USB_CNT=$(($USB_CNT+1))
	fi

	if [[ "$(lsusb -t | grep "Port 4")" ]]; then
		USB_CNT=$(($USB_CNT+1))
	fi

	if [[ "$USB_CNT" == "2" ]]; then
		echo "pass stage 1"
	else
		echo fail > /tmp/usb_qc.txt
		sleep 3
		continue
	fi

	PORT3_CNT=$(lsusb -t | grep "Port 3" | wc -l)
	PORT4_CNT=$(lsusb -t | grep "Port 4" | wc -l)
	PORT_TOTAL=$(($PORT3_CNT+$PORT4_CNT))

	STORAGE_CNT=$(lsusb -t | grep "usb-storage" | wc -l)
	HID_CNT=$(lsusb -t | grep "usbhid" | wc -l)
	TOTAL_CNT=$(($STORAGE_CNT+$HID_CNT))

	if [[ "$TOTAL_CNT" == "$PORT_TOTAL" ]]; then
		echo pass > /tmp/usb_qc.txt
	else
		echo fail > /tmp/usb_qc.txt
	fi
	sleep 3
done
