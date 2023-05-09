#!/bin/sh

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

headset_test()
{
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

	if [ $? == 0 ];then
		echo "pass" > /tmp/audio_headset_qc.txt
	else
		echo "fail" > /tmp/audio_headset_qc.txt
	fi
	kill -9 $REC_PID
	kill -9 $PLAY_PID
	dd if=/dev/zero of=/dev/fb0
	kill -9 $$
}

DMIC_loopback_test()
{
	sh -c 'dialog --colors --title "DMIC Loopback Test" \
	--no-collapse --msgbox "\nStart test when you choose \"OK\" \nListening about 5 secs...\nPlease plug-out headset first" 10 50 \
	<> /dev/tty1 >&0 2>&1'

	#B643 do not have dmic
	if [ $SOC == "B664" ];then
		amixer -c 0 sset 'Mono ADC' '127'
		amixer -c 0 sset 'STO1 ADC Boost Gain' '1'
		arecord -D hw:$AUD_CARD -f dat -c1 | aplay -D hw:$AUD_CARD -f dat -c1 &
		REC_PID=$(ps | grep arecord | head -1 | awk  '{print $1}')
		PLAY_PID=$(ps | grep aplay | head -1 | awk  '{print $1}')
		kill -9 $REC_PID
		kill -9 $PLAY_PID
		arecord -D hw:$AUD_CARD -f dat | aplay -D hw:$AUD_CARD -f dat &
		sleep 5
	
		REC_PID=$(ps | grep arecord | head -1 | awk  '{print $1}')
		PLAY_PID=$(ps | grep aplay | head -1 | awk  '{print $1}')
	else
		echo "fail" > /tmp/audio_dmic_loopback_qc.txt
		return
	fi
	sh -c 'dialog --colors --title "DMIC Loopback Test" \
	--no-collapse --yesno "Hear sound?" 10 50 \
	<> /dev/tty1 >&0 2>&1'
	
	if [ $? == 0 ];then
		echo "pass" > /tmp/audio_dmic_loopback_qc.txt
	else
		echo "fail" > /tmp/audio_dmic_loopback_qc.txt
	fi
	kill -9 $REC_PID
	kill -9 $PLAY_PID

	amixer -c 0 sset 'STO1 ADC Boost Gain' '0'

	dd if=/dev/zero of=/dev/fb0
	kill -9 $$
}

speaker_test()
{
	#louder test wav for speaker-test
	if [ $SOC == "B664" ];then
		cp /usr/share/sounds/alsa/Front_Left_new.wav /usr/share/sounds/alsa/Front_Left.wav
		cp /usr/share/sounds/alsa/Front_Right_new.wav /usr/share/sounds/alsa/Front_Right.wav
		sync
	fi

	sh -c 'dialog --colors --title "Speaker Test" \
	--no-collapse --msgbox "\nStart test when you choose \"OK\" \nListening about 5 secs...\nPlease plug-out headset first" 10 50 \
	<> /dev/tty1 >&0 2>&1'
	speaker-test -t wav -c 2 -D hw:$AUD_CARD &
	sleep 5
	
	SPK_PID=$(ps | grep speaker-test | head -1 | awk  '{print $1}')

	sh -c 'dialog --colors --title "DMIC/Speaker Test" \
	--no-collapse --yesno "Hear sound?" 10 50 \
	<> /dev/tty1 >&0 2>&1'
	
	if [ $? == 0 ];then
		echo "pass" > /tmp/audio_speaker_qc.txt
	else
		echo "fail" > /tmp/audio_speaker_qc.txt
	fi

	kill -9 $SPK_PID
	dd if=/dev/zero of=/dev/fb0
	kill -9 $$
}

SOC=`cat /proc/device-tree/model | cut -d ' ' -f3`
if [ $SOC == "B664" ];then
	AUD_CARD=0
elif [ $SOC == "B643" ];then
	AUD_CARD=1
fi

if [ -d /sys/class/i2c-dev/i2c-2/device/2-001c/ ]; then
    echo "codec existed, starting test"
else
	echo "fail" > /tmp/audio_headset_qc.txt
	echo "fail" > /tmp/audio_dmic_loopback_qc.txt
	echo "fail" > /tmp/audio_speaker_qc.txt
	exit 1
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

case $1 in
	headset)
		headset_test
		;;
	DMIC)
		DMIC_loopback_test
		;;
	speaker)
		speaker_test
		;;
esac
