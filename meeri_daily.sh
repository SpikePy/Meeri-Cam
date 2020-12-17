#!/bin/bash
cd /var/www/html/ramdisk/
time ffmpeg -r 7 -pattern_type glob -i "*$(date +%Y%m%d)*.webp" -c:v libx264 meeri_daily_$(date %Y%m%d).mp4
cp meeri_daily_* ~
