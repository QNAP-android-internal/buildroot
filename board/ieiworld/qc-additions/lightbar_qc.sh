#!/bin/sh

led_stress_run() {
while true
do
    # Enable Red
    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

    sleep 5

    # Turn off Red
    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

    sleep 1

    # Enable Green
    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

    sleep 5

    # Turn off green
    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

    sleep 1

    # Enable blue
    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"

    sleep 5

    # Turn off blue
    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"

    sleep 1

    #Enable RGB, should be White status
    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

    # LBAR 1
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
    echo 100 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

    # LBAR 2
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
    echo 100 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"

    sleep 5

    #turn off RGB
    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

    # LBAR 1
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
    echo 0 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

    # LBAR 2
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
    echo 0 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"
done
}

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

LBAR_PATH1="/sys/bus/i2c/devices/1-0060/leds/"
LBAR_PATH2="/sys/bus/i2c/devices/3-0060/leds/"

if [ -f $LBAR_PATH1/i2c2_led_red_00/brightness ]; then
    echo "lightbar-1 existed, checking lightbar-2"
else
    echo "fail" > /tmp/lightbar_qc.txt
fi

if [ -f $LBAR_PATH2/i2c4_led_blue_00/brightness ]; then
    echo "lightbar-2 existed, starting test.."
else
    echo "fail" > /tmp/lightbar_qc.txt
fi

# Turn off
# LBAR 1
echo 0 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

# LBAR 2
echo 0 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

# LBAR 1
echo 0 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

# LBAR 2
echo 0 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

# LBAR 1
echo 0 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
echo 0 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

# LBAR 2
echo 0 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
echo 0 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"

# LBAR 1
echo 100 > "$LBAR_PATH1/i2c2_led_red_00/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_red_01/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_red_02/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_red_03/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_red_04/brightness"

echo 100 > "$LBAR_PATH1/i2c2_led_green_00/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_green_01/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_green_02/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_green_03/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_green_04/brightness"

echo 100 > "$LBAR_PATH1/i2c2_led_blue_00/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_blue_01/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_blue_02/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_blue_03/brightness"
echo 100 > "$LBAR_PATH1/i2c2_led_blue_04/brightness"

# LBAR 2
echo 100 > "$LBAR_PATH2/i2c4_led_red_00/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_red_01/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_red_02/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_red_03/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_red_04/brightness"

echo 100 > "$LBAR_PATH2/i2c4_led_green_00/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_green_01/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_green_02/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_green_03/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_green_04/brightness"

echo 100 > "$LBAR_PATH2/i2c4_led_blue_00/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_blue_01/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_blue_02/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_blue_03/brightness"
echo 100 > "$LBAR_PATH2/i2c4_led_blue_04/brightness"

sleep 2

sh -c 'dialog --colors --title "LightBar Test" \
--no-collapse --yesno "See White light on Lightbars?" 10 50 \
<> /dev/tty1 >&0'

LBAR_RESULTS="$?"
if [[ "$LBAR_RESULTS" == '1' ]]; then
    echo "fail" > /tmp/lightbar_qc.txt
elif [[ "$LBAR_RESULTS" == '0' ]]; then
    echo "pass" > /tmp/lightbar_qc.txt
fi

dd if=/dev/zero of=/dev/fb0

led_stress_run &
