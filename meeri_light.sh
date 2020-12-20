#!/bin/bash


## [ Parameters ] ##############################################################
sensor_filepath=/var/www/html/ramdisk/current.webp
threshold=40
GPIO=17

## [ Logic ] ##################################################################
# Enable GPIO and set it as output
echo "${GPIO}" > /sys/class/gpio/export > /dev/null || true
echo "out"     > /sys/class/gpio/gpio17/direction

while true; do
  sensor_value=$(du ${sensor_filepath} | cut -f1)
  if [ ${sensor_value:-100} -lt ${threshold} ]; then
    # Switch light on
    echo 1 > /sys/class/gpio/gpio17/value
  else
    # Switch light off
    echo 0 > /sys/class/gpio/gpio17/value
  fi
  sleep 10
done

