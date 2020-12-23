#!/bin/bash
source $(dirname $0)/env

## [ Parameters ] ##############################################################
filepath_log=${filepath_log}

light_gpio_pin=${light_gpio_pin}
light_photo_filepath=${light_photo_filepath}
light_on_photoSizeBelow_kb=${light_on_photoSizeBelow_kb}
light_off_photoSizeAbove_kb=${light_off_photoSizeAbove_kb}
sensor_intervall=${photo_intervall}


## [ Logic ] ##################################################################
# Disable GPIO when exiting
trap "echo \"${light_gpio_pin}\" > /sys/class/gpio/unexport && echo \"GPIO ${light_gpio_pin} disabled\"" EXIT

# Enable GPIO and set it as output
if [ ! -d /sys/class/gpio/gpio${light_gpio_pin} ];then
  echo "${light_gpio_pin}" > /sys/class/gpio/export
  sleep 1
  echo "GPIO ${light_gpio_pin} enabled"
else
  echo "GPIO ${light_gpio_pin} already enabled"
fi

if [ "$(cat /sys/class/gpio/gpio${light_gpio_pin}/direction)" != "out" ]; then
  echo "out" > /sys/class/gpio/gpio${light_gpio_pin}/direction
  echo "GPIO ${light_gpio_pin} configured as output"
else
  echo "GPIO ${light_gpio_pin} already configured as output"
fi


if [ ! $(pgrep fswebcam) ]; then
  echo "Webcam not recording, switching to manual mode"
  echo "1" > /sys/class/gpio/gpio${light_gpio_pin}/value
else
  echo "Analyzing Webcam images to control the fairy lights"
  while [ $(pgrep fswebcam) ]; do
    sensor_value=$(du ${light_photo_filepath} | cut -f1)
    if [ ${sensor_value:-100} -lt ${light_on_photoSizeBelow_kb} ]; then
      echo "Switch light on: $(date +\"%Y-%m-%d %H:%M:%S\")"| tee -a ${filepath_log}
      echo "1" > /sys/class/gpio/gpio${light_gpio_pin}/value
    elif [ ${sensor_value:-100} -ge ${light_off_photoSizeAbove_kb} ]; then
      echo "Switch light off: $(date +\"%Y-%m-%d %H:%M:%S\")"| tee -a ${filepath_log}
      echo "0" > /sys/class/gpio/gpio${light_gpio_pin}/value
    fi
    sleep ${sensor_intervall}
  done
fi
