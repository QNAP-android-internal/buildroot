#!/bin/sh

echo "fail" > /tmp/modem_qc.txt

while true
do
        MODULE=$(mmcli -m 0 | grep "h/w revision" | awk -F: '{print $2}')
        if [[ "$MODULE" == " EM7455" ]];then
                echo "pass" > /tmp/modem_qc.txt
                break
        fi

        sleep 1
done

systemctl stop NetworkManager
