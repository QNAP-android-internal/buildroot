for i in `seq 1 100`; do
    buzzValue=$i
    #buzzValue=$(( $i *10 ))
    echo "buzzValue : $buzzValue"
    echo $buzzValue>/sys/class/backlight/buzzer_pwm/brightness
    sleep 0.5
done

