#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`
if [ $SOC == "B664" ];then
	AUD_CARD=0
elif [ $SOC == "B643" ];then
	AUD_CARD=1
fi

if [ -f /sys/class/i2c-dev/i2c-2/device/2-001c/ ]; then
    echo "codec existed, starting test"
else
    echo "fail" > /tmp/audio_qc.txt
fi

# for alc5672
amixer -c $AUD_CARD sset 'IN1 Boost' '2'
amixer -c $AUD_CARD sset 'RECMIXL BST1' 'on'
amixer -c $AUD_CARD sset 'RECMIXR BST1' 'on'
amixer -c $AUD_CARD sset 'Sto1 ADC MIXL ADC1' 'on'
amixer -c $AUD_CARD sset 'Sto1 ADC MIXL ADC2' 'on'
amixer -c $AUD_CARD sset 'Sto1 ADC MIXR ADC1' 'on'
amixer -c $AUD_CARD sset 'Sto1 ADC MIXR ADC2' 'on'
amixer -c $AUD_CARD sset 'Sto2 ADC MIXL ADC1' 'on'
amixer -c $AUD_CARD sset 'Sto2 ADC MIXL ADC2' 'on'
amixer -c $AUD_CARD sset 'Sto2 ADC MIXR ADC1' 'on'
amixer -c $AUD_CARD sset 'Sto2 ADC MIXR ADC2' 'on'
amixer -c $AUD_CARD sset 'Stereo DAC MIXL DAC L1' 'on'
amixer -c $AUD_CARD sset 'Stereo DAC MIXR DAC R1' 'on'

amixer -c $AUD_CARD sset 'HPOVOL MIXL DAC1' 'on'
amixer -c $AUD_CARD sset 'HPOVOL MIXR DAC1' 'on'
amixer -c $AUD_CARD sset 'HPO MIX HPVOL' 'on'
amixer -c $AUD_CARD sset 'PDM1 L Mux' 'Stereo DAC'
amixer -c $AUD_CARD sset 'PDM1 R Mux' 'Stereo DAC'


sh -c 'dialog --colors --title "Headset Test" \
--no-collapse --msgbox "\nStart test when you choose \"OK\" \nListening about 5 secs..." 10 50 \
<> /dev/tty1 >&0 2>&1'

arecord -D hw:$AUD_CARD -f dat | aplay -D hw:$AUD_CARD -f dat &

sleep 5

REC_PID=$(ps | grep arecord | head -1 | awk  '{print $1}')
PLAY_PID=$(ps | grep aplay | head -1 | awk  '{print $1}')

sh -c 'dialog --colors --title "Headset Test" \
--no-collapse --yesno "Hear loopback sound?" 10 50 \
<> /dev/tty1 >&0 2>&1'

AUDIO_RESULTS="$?"
if [[ "$AUDIO_RESULTS" == '1' ]]; then
        echo "fail" > /tmp/audio_qc.txt
	kill -9 $REC_PID
	kill -9 $PLAY_PID
	dd if=/dev/zero of=/dev/fb0
	kill -9 $$
	exit
fi

kill -9 $REC_PID
kill -9 $PLAY_PID

sh -c 'dialog --colors --title "DMIC/Speaker Test" \
--no-collapse --msgbox "\nStart test when you choose \"OK\" \nListening about 5 secs...\nPlease plug-out headset first" 10 50 \
<> /dev/tty1 >&0 2>&1'

if [ $SOC == "B664" ];then
	arecord -D hw:$AUD_CARD -f dat | aplay -D hw:$AUD_CARD -f dat &
elif [ $SOC == "B643" ];then
        speaker-test -t wav -c 2 -D hw:$AUD_CARD &
fi

sleep 5

REC_PID=$(ps | grep arecord | head -1 | awk  '{print $1}')
PLAY_PID=$(ps | grep aplay | head -1 | awk  '{print $1}')
SPK_PID=$(ps | grep speaker-test | head -1 | awk  '{print $1}')

sh -c 'dialog --colors --title "DMIC/Speaker Test" \
--no-collapse --yesno "Hear sound?" 10 50 \
<> /dev/tty1 >&0 2>&1'

AUDIO_RESULTS="$?"
if [[ "$AUDIO_RESULTS" == '1' ]]; then
        echo "fail" > /tmp/audio_qc.txt
	kill -9 $REC_PID
	kill -9 $PLAY_PID
	kill -9 $SPK_PID
elif [[ "$AUDIO_RESULTS" == '0' ]]; then
        echo "pass" > /tmp/audio_qc.txt
fi

kill -9 $REC_PID
kill -9 $PLAY_PID
kill -9 $SPK_PID

dd if=/dev/zero of=/dev/fb0

kill -9 $$
