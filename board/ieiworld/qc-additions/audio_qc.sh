#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/


if [ -f /sys/class/i2c-dev/i2c-2/device/2-0010/ ]; then
	echo "codec existed, starting test"
else
	echo "Failed"
fi

amixer sset 'Volume Adjustment Smoothing' 'off'  
amixer sset 'DAC Mono Mode' 'on' 
amixer sset 'LINEA Mixer IN5' 'on'
amixer sset 'Left ADC Mixer LINEA' 'on'

arecord -f dat | aplay -f dat &

sleep 2

REC_PID=$(ps | grep arecord | head -1 | awk  '{print $1}')
PLAY_PID=$(ps | grep aplay | head -1 | awk  '{print $1}')

sh -c 'dialog --colors --title "Audio Test" \
--no-collapse --yesno "Hear MIC sound?" 10 50 \
<> /dev/tty1 >&0'

AUDIO_RESULTS="$?"
if [[ "$AUDIO_RESULTS" == '1' ]]; then
        echo "Failed"
elif [[ "$AUDIO_RESULTS" == '0' ]]; then
        echo "Pass"
fi

kill -9 $REC_PID
kill -9 $PLAY_PID
dd if=/dev/zero of=/dev/fb0

kill -9 $$
