#!/bin/bash
clear

mkdir --parents /var/www/html/ramdisk/thumbnails

fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --fps 10 \
  --skip 1 \
  --jpeg 100 \
  --loop 10 \
  --save /var/www/html/ramdisk/current.jpg \
  --exec 'cwebp -quiet -q 85 /var/www/html/ramdisk/current.jpg -o /var/www/html/ramdisk/buffer.webp;
          mv /var/www/html/ramdisk/buffer.webp /var/www/html/ramdisk/current.webp;
          cp /var/www/html/ramdisk/current.jpg /var/www/html/ramdisk/$(date +%Y%m%d_%H%M%S).jpg;
          ~/*/image_filter.sh;
	  test -f current.jpg && cp /var/www/html/ramdisk/current.webp /var/www/html/ramdisk/$(date +%Y%m%d_%H%M%S).webp;
          test -f current.jpg && cwebp -quiet -q 70 /var/www/html/ramdisk/current.jpg -resize 480 0 -o /var/www/html/ramdisk/thumbnails/$(date +%Y%m%d_%H%M%S).webp;
          rm /var/www/html/ramdisk/current.jpg'
