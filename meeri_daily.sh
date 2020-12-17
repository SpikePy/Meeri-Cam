#!/bin/bash
cd /var/www/html/ramdisk/
time ffmpeg -n -r 7 -pattern_type glob -i "*$(date +%Y%m%d)*.webp" -c:v libx264 ../persistent/meeri_daily_$(date +%Y%m%d).mp4
