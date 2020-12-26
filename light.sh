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


echo -n "Wait for webcam to analyze brigthness"
while [ ! $(pgrep fswebcam) ]; do
  echo -n "."
  sleep 1
  let i+=1
  test ${i:=0} -gt 60 && break
done; echo

while true; do
  if [ ! $(pgrep fswebcam) ]; then
    echo "Webcam not recording, switching to manual mode"
    echo "1" > /sys/class/gpio/gpio${light_gpio_pin}/value
    sleep 5m
  else
    echo "Analyzing webcam images to control fairy lights"
    while [ $(pgrep fswebcam) ]; do
      sensor_value=$(du ${light_photo_filepath} | cut -f1)
      if [ ${sensor_value:-100} -lt ${light_on_photoSizeBelow_kb} ]; then
        if [ ${count_switch_treshold_exceetions:=0} -le -15 ]; then
          if [ "${toggle:=off}" = "off"]; then echo "Switch fairy light on: $(date +'%d.%m.%Y %H:%M:%S') - ${sensor_value}"| tee -a ${filepath_log}; fi
          toggle=on
          echo "1" > /sys/class/gpio/gpio${light_gpio_pin}/value
        else
          let count_switch_treshold_exceetions-=1
        fi
      elif [ ${sensor_value:-100} -ge ${light_off_photoSizeAbove_kb} ]; then
        if [ ${count_switch_treshold_exceetions:=0} -ge 15 ]; then
          if [ "${toggle:=off}" = "on"]; then echo "Switch fairy light off: $(date +'%d.%m.%Y %H:%M:%S') - ${sensor_value}"| tee -a ${filepath_log}; fi
          toggle=off
          echo "0" > /sys/class/gpio/gpio${light_gpio_pin}/value
        else
          let count_switch_treshold_exceetions+=1
        fi
      fi
      echo "Number exceeded thresholds: ${count_switch_treshold_exceetions}"
      sleep ${sensor_intervall}
    done
  fi
done
