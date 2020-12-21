#!/bin/bash
source ~/Meeri-Cam/env
clear


## [ Parameters ] #############################################################
export date_time=${date_time}
export path_photos=${path_html_ramdisk}
export filename_photo_latest=${filename_photo_latest}
export path_thumbnails=${path_photos}/thumbnails
export photo_intervall=${photo_intervall}

## [ Logic ] ##################################################################
mkdir --parents ${path_thumbnails}

fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --fps 10 \
  --skip 1 \
  --jpeg 100 \
  --loop ${photo_intervall} \
  --save ${path_photos}/${filename_photo_latest}.jpg \
  --exec 'cwebp -quiet -q 85 ${path_photos}/${filename_photo_latest}.jpg -o ${path_photos}/buffer.webp;
          mv  ${path_photos}/buffer.webp  ${path_photos}/${filename_photo_latest}.webp;
          echo "filesize = $(du ${path_photos}/${filename_photo_latest}.webp | cut -f1)" > ${path_photos}/${filename_photo_latest}.js;
	  cp ${path_photos}/${filename_photo_latest}.webp ${path_photos}/${date_time}.webp;
          cwebp -quiet -q 70 ${path_photos}/${filename_photo_latest}.jpg -resize 480 0 -o ${path_thumbnails}/${date_time}.webp;
          rm ${path_photos}/${filename_photo_latest}.jpg'
