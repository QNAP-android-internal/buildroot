#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/


if [ -f /sys/class/backlight/buzzer_pwm/brightness ]; then
    echo "buzzer existed, starting test"
else
    echo "Failed"
fi


for i in $(seq 1 90);
do
    echo "$i" >  /sys/class/backlight/buzzer_pwm/brightness
    sleep 0.01
done

sh -c 'dialog --colors --title "Buzzer Test" \
--no-collapse --yesno "Hear buzzer sound??" 10 50 \
<> /dev/tty1 >&0'

BUZZER_RESULTS="$?"
if [[ "$BUZZER_RESULTS" == '1' ]]; then
    echo "Failed"
elif [[ "$BUZZER_RESULTS" == '0' ]]; then
    echo "Pass"
fi

echo 0 >  /sys/class/backlight/buzzer_pwm/brightness

dd if=/dev/zero of=/dev/fb0
kill -9 $$
