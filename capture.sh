#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] #############################################################
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
  --save ${path_photos}/${filename_photo_latest%.*}.jpg \
  --exec 'cwebp -quiet -q 85 ${path_photos}/${filename_photo_latest%.*}.jpg -o ${path_photos}/buffer.webp;
          ln -f ${path_photos}/buffer.webp  ${path_photos}/${filename_photo_latest};
          cp ${path_photos}/${filename_photo_latest} ${path_photos}/$(date +%Y%m%d_%H%M%S).webp;
          cwebp -quiet -q 70 ${path_photos}/${filename_photo_latest%.*}.jpg -resize 480 0 -o ${path_thumbnails}/$(date +%Y%m%d_%H%M%S).webp;
          rm ${path_photos}/${filename_photo_latest%.*}.jpg'
