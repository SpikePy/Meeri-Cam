#!/bin/bash
time_start=$(date +%s)
clear


## [ Parameters ] ##############################################################
path_images=/var/www/html/ramdisk
path_video=/var/www/html/persistent
logfile=~/meeri_cam.log


## [ Logic ] ###################################################################
cd ${path_images}

# Convert images to video (https://trac.ffmpeg.org/wiki/Encode/H.264)
time ffmpeg -n -r 10 -pattern_type glob -i "$(date +%Y%m%d)*.webp" -c:v libx264 -preset medium -crf 32 ${path_video}/meeri_daily_$(date +%Y%m%d).mp4

# crf:    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
# preset: A preset is a collection of options that will provide a certain encoding speed to compression ratio. A slower preset will provide better compression (compression is quality per filesize).

time_finished=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${logfile}
Meeri Daily
===========
Execution time: $(( time_finish - time_start ))s
Files Size: $(du -hc ${path_images}/$(date +%Y%m%d)*.webp | tail -n1 | cut -f1)
Video Size: $(du -h  ${path_video}/meeri_daily_$(date +%Y%m%d).mp4 | cut -f1)

EOF
