#!/bin/sh

if [[ "$(cat /proc/device-tree/model | grep "B643")" ]]; then
	echo "prepare to start"
else
	echo fail > /tmp/gpio_qc.txt
fi

# check loopback 1-2
gpioset gpiochip5 8=1
GET_VAL=$(gpioget gpiochip5 9)
if [[ "$GET_VAL" != 1 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

gpioset gpiochip5 8=0
GET_VAL=$(gpioget gpiochip5 9)
if [[ "$GET_VAL" != 0 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi


# check loopback 3-4
gpioset gpiochip5 10=1
GET_VAL=$(gpioget gpiochip5 11)
if [[ "$GET_VAL" != 1 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

gpioset gpiochip5 10=0
GET_VAL=$(gpioget gpiochip5 11)
if [[ "$GET_VAL" != 0 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi


# check loopback 5-6
gpioset gpiochip5 12=1
GET_VAL=$(gpioget gpiochip5 13)
if [[ "$GET_VAL" != 1 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

gpioset gpiochip5 12=0
GET_VAL=$(gpioget gpiochip5 13)
if [[ "$GET_VAL" != 0 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

# check loopback 7-8
gpioset gpiochip5 14=1
GET_VAL=$(gpioget gpiochip5 15)
if [[ "$GET_VAL" != 1 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

gpioset gpiochip5 14=0
GET_VAL=$(gpioget gpiochip5 15)
if [[ "$GET_VAL" != 0 ]]; then
	echo "fail" > /tmp/gpio_qc.txt
	exit
fi

echo "pass" > /tmp/gpio_qc.txt
