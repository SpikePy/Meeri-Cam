#!/bin/bash
cd /var/www/html/ramdisk/
find . -type f -size -20k -delete
time ffmpeg -n -r 7 -pattern_type glob -i "*$(date +%Y%m%d)*.webp" -c:v libx264 ../persistent/meeri_daily_$(date +%Y%m%d).mp4
