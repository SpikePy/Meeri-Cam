#!/bin/bash
clear


## [ Parameters ] #############################################################
# Image path
export path=/var/www/html/ramdisk
# Image name
export filename=current


## [ Logic ] ##################################################################
mkdir --parents ${path}/thumbnails

fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --fps 10 \
  --skip 1 \
  --jpeg 100 \
  --loop 10 \
  --save ${path}/${filename}.jpg \
  --exec 'cwebp -quiet -q 85 ${path}/${filename}.jpg -o ${path}/buffer.webp;
          mv  ${path}/buffer.webp  ${path}/${filename}.webp;
	  cp ${path}/${filename}.webp ${path}/$(date +%Y%m%d_%H%M%S).webp;
          cwebp -quiet -q 70 ${path}/${filename}.jpg -resize 480 0 -o ${path}/thumbnails/$(date +%Y%m%d_%H%M%S).webp;
          rm ${path}/${filename}.jpg'
