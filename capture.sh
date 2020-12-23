#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] #############################################################
export command_date_time=${command_date_time}
export path_photos=${path_html_ramdisk}
export filename_photo_latest=${filename_photo_latest}
export gpio_photo_filepath=${gpio_photo_filepath}
export path_thumbnails=${path_photos}/thumbnails
export photo_intervall=${photo_intervall}

## [ Logic ] ##################################################################
# MAke sure capturing is stopped when exiting
trap "pkill fswebcam" EXIT

mkdir --parents ${path_thumbnails}

# Kill fswebcam if it is already running
# because just one application can use the device
pkill fswebcam

fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --fps 10 \
  --jpeg 100 \
  --loop ${photo_intervall} \
  --save ${path_photos}/${filename_photo_latest%.*}.jpg \
  --exec 'cwebp -quiet -q 85 ${path_photos}/${filename_photo_latest%.*}.jpg -o ${path_photos}/buffer.webp;
          cp ${path_photos}/buffer.webp ${path_photos}/${filename_photo_latest};
          cp ${path_photos}/buffer.webp ${gpio_photo_filepath};
          cp ${path_photos}/${filename_photo_latest} ${path_photos}/$(eval ${command_date_time}).webp;
          cwebp -quiet -q 70 ${path_photos}/${filename_photo_latest%.*}.jpg -resize 480 0 -o ${path_thumbnails}/$(eval ${command_date_time}).webp;
          rm ${path_photos}/${filename_photo_latest%.*}.jpg'
