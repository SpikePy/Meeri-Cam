#!/bin/bash
source $(dirname $0)/env

## [ Parameters ] ##############################################################
gpio_pin=${gpio_pin}
gpio_sensor_filepath=${gpio_photo_filepath}
sensor_threshold=${gpio_threshold_photo_size_kb}
sensor_intervall=${photo_intervall}

## [ Logic ] ##################################################################
# Enable GPIO and set it as output
echo "${gpio_pin}" > /sys/class/gpio/export || true
echo "out"         > /sys/class/gpio/gpio17/direction

while true; do
  sensor_value=$(du ${gpio_sensor_filepath} | cut -f1)
  if [ ${sensor_value:-100} -lt ${sensor_threshold} ]; then
    # Switch light on
    echo "1" > /sys/class/gpio/gpio${gpio_pin}/value
  else
    # Switch light off
    echo "0" > /sys/class/gpio/gpio${gpio_pin}/value
  fi
  sleep ${sensor_intervall}
done
