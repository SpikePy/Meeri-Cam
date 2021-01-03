#!/bin/bash
source $(dirname $0)/env.sh


## [ Parameters ] ##############################################################
filepath_log=${filepath_log}

light_gpio_pin=${light_gpio_pin}
light_photo_filepath=${light_photo_filepath}


## [ Logic ] ##################################################################
# Disable GPIO when exiting
function exit_trap {
    echo "${light_gpio_pin}" > /sys/class/gpio/unexport
    echo "GPIO ${light_gpio_pin} disabled"
    systemd-cat --identifier ${0} --priority info echo "GPIO ${light_gpio_pin} disabled"
}
trap exit_trap EXIT

# Enable GPIO and set it as output
if [ ! -d /sys/class/gpio/gpio${light_gpio_pin} ];then
  echo "${light_gpio_pin}" > /sys/class/gpio/export
  sleep 1
  echo "GPIO ${light_gpio_pin} enabled"
  systemd-cat --identifier ${0} --priority info echo "GPIO ${light_gpio_pin} enabled"
else
  echo "GPIO ${light_gpio_pin} already enabled"
  systemd-cat --identifier ${0} --priority info echo "GPIO ${light_gpio_pin} already enabled"
fi

if [ "$(cat /sys/class/gpio/gpio${light_gpio_pin}/direction)" != "out" ]; then
  echo "out" > /sys/class/gpio/gpio${light_gpio_pin}/direction
  echo "GPIO ${light_gpio_pin} configured as output"
  systemd-cat --identifier ${0} --priority info echo "GPIO ${light_gpio_pin} configured as output"
else
    echo "GPIO ${light_gpio_pin} already configured as output"
  systemd-cat --identifier ${0} --priority info echo "GPIO ${light_gpio_pin} already configured as output"
fi
echo

while true; do
    _date=$(date +%m%d)
    _time=$(date +%H%M)
    dawn=dawn${_date}
    dusk=dusk${_date}
    if [ ${_time} -ge ${!dawn} ] && [ ${_time} -le ${!dusk} ]; then
        echo "0" > /sys/class/gpio/gpio${light_gpio_pin}/value
        if [ ${toggle:=0} -eq 1 ]; then
            echo "Switch fairy light off"
            systemd-cat --identifier ${0} --priority info echo "Switch fairy light off"
        fi
        toggle=0
    else
        echo "1" > /sys/class/gpio/gpio${light_gpio_pin}/value
        if [ ${toggle:=0} -eq 0 ]; then
            echo "Switch fairy light on"
            systemd-cat --identifier ${0} --priority info echo "Switch fairy light on"
        fi
        toggle=1
    fi
    sleep 1m
done
