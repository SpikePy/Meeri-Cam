#!/bin/bash

fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --jpeg 95 \
  --loop 30 \
  --save /var/www/html/ramdisk/latest.jpg \
  --exec 'cwebp -quiet -q 85 /var/www/html/ramdisk/latest.jpg -o /var/www/html/ramdisk/buffer.webp;
          rm /var/www/html/ramdisk/latest.jpg;
          mv /var/www/html/ramdisk/buffer.webp /var/www/html/ramdisk/latest.webp;
          cp /var/www/html/ramdisk/latest.webp /var/www/html/ramdisk/$(date +%Y%m%d_%H%M%S).webp'
