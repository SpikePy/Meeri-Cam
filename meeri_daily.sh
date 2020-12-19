#!/bin/bash

cd /var/www/html/ramdisk/
clear

# Convert images to video (https://trac.ffmpeg.org/wiki/Encode/H.264)
time ffmpeg -n -r 10 -pattern_type glob -i "*$(date +%Y%m%d)*.webp" -c:v libx264 -preset medium -crf 32 ../persistent/meeri_daily_$(date +%Y%m%d).mp4

# crf:    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
# preset: A preset is a collection of options that will provide a certain encoding speed to compression ratio. A slower preset will provide better compression (compression is quality per filesize).
