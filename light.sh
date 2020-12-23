#!/bin/bash
source $(dirname $0)/env

## [ Parameters ] ##############################################################
export gpio_pin=${gpio_pin}
export gpio_sensor_filepath=${gpio_photo_filepath}
export path_photos=${path_html_ramdisk}
export filename_photo_latest=${filename_photo_latest}
export sensor_threshold=${gpio_threshold_photo_size_kb}
export sensor_intervall=${photo_intervall}


## [ Logic ] ##################################################################
# Disable GPIO when exiting
trap "echo \"${gpio_pin}\" > /sys/class/gpio/unexport" EXIT

# Enable GPIO and set it as output
test -d /sys/class/gpio/${gpio_pin} || echo "${gpio_pin}" > /sys/class/gpio/export

sleep 1
echo "out" > /sys/class/gpio/gpio17/direction

while true; do
  camera_status=$(pgrep fswebcam)
  if [ -z "${camera_status}" ]; then
    echo "fswebcam not running, starting it"
    sleep ${sensor_intervall}
    fswebcam \
      --background \
      --resolution 1280x1024 \
      --no-banner \
      --frames 20 \
      --fps 10 \
      --skip 1 \
      --jpeg 100 \
      --loop ${sensor_intervall} \
      --save ${path_photos}/${filename_photo_latest%.*}.jpg \
      --exec 'cwebp -quiet -q 85 ${path_photos}/${filename_photo_latest%.*}.jpg -o ${path_photos}/buffer.webp;
              rm ${path_photos}/${filename_photo_latest%.*}.jpg;
              cp ${path_photos}/buffer.webp ${gpio_sensor_filepath}'
  fi

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
