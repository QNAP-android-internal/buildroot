#!/bin/sh

if [ -f /tmp/usb_qc.txt ];then
	rm /tmp/usb_qc.txt
fi

PORT_A="Port 1"
PORT_B="Port 2"

while true
do
	USB_CNT=0

	if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
		PORT_A="Port 3"
		PORT_B="Port 4"
		if [[ "$(lsusb -t | grep "$PORT_A")" ]]; then
			USB_CNT=$(($USB_CNT+1))
		fi

	elif [[ "$(cat /proc/device-tree/model | grep "B664")" ]]; then
		PORT_A="Port 1"
		PORT_B="Port 2"
		if [[ "$(lsusb -t | grep "$PORT_A" | grep -v "ci_hdrc" | grep -v "hub/7p")" ]]; then
			USB_CNT=$(($USB_CNT+1))
		fi

	else
		PORT_A="Port 3"
		PORT_B="Port 4"
		if [[ "$(lsusb -t | grep "$PORT_A")" ]]; then
			USB_CNT=$(($USB_CNT+1))
		fi
	fi

	if [[ "$(lsusb -t | grep "$PORT_B")" ]]; then
		USB_CNT=$(($USB_CNT+1))
	fi

	if [[ "$USB_CNT" == "2" ]]; then
		echo "pass stage 1"
	else
		echo fail > /tmp/usb_qc.txt
		sleep 3
		continue
	fi

	PORTA_STORAGE_CNT=$(lsusb -t | grep "$PORT_A" | grep "usb-storage" | wc -l)
	PORTA_HID_CNT=$(lsusb -t | grep "$PORT_A" | grep "usbhid" | wc -l)
	PORTB_STORAGE_CNT=$(lsusb -t | grep "$PORT_B" | grep "usb-storage" | wc -l)
	PORTB_HID_CNT=$(lsusb -t | grep "$PORT_B" | grep "usbhid" | wc -l)
	PORT_TOTAL=$(($PORTA_STORAGE_CNT+$PORTA_HID_CNT+$PORTB_STORAGE_CNT+$PORTB_HID_CNT))

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
