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
# Enable GPIO and set it as output
echo "${gpio_pin}" > /sys/class/gpio/export || true
while [ "$(cat /sys/class/gpio/gpio17/direction)" != "out" ]; do
  # TODO: view log on restart
  echo "${date +%Y%m%d} gpio${gpio_pin} set to: $(cat /sys/class/gpio/gpio17/direction)" | tee -a ~/light.log
  echo "out" > /sys/class/gpio/gpio17/direction
  sleep 1
done

while true; do
  camera_status=$(pgrep fswebcam)
  if [ ${camera_status} -ne 0 ]; then
    sleep ${sensor_intervall}
    fswebcam \
      --resolution 1280x1024 \
      --no-banner \
      --frames 20 \
      --fps 10 \
      --skip 1 \
      --jpeg 100 \
      --loop ${sensor_intervall} \
      --save ${path_photos}/${filename_photo_latest%.*}.jpg \
      --exec 'cwebp -quiet -q 85 ${path_photos}/${filename_photo_latest%.*}.jpg -o ${path_photos}/buffer.webp;
              cp ${path_photos}/buffer.webp ${gpio_photo_filepath};
              rm ${path_photos}/${filename_photo_latest%.*}.jpg'
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
