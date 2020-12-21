#!/bin/bash
source $(dirname $0)/env
clear


## [ Parameters ] ##############################################################
path_pictures=${path_html_ramdisk}
path_video=${path_html_persistent}
filepath_video_date=${filepath_video_date}
filepath_log=${filepath_log}
upload_onedrive=${upload_onedrive}
path_upload_onedrive=${path_upload_onedrive}
date=${date}


## [ Logic ] ###################################################################
time_start=$(date +%s)
cd ${path_pictures}

# Convert images to video (https://trac.ffmpeg.org/wiki/Encode/H.264)
time ffmpeg -n -r 10 -pattern_type glob -i "${date}*.webp" -c:v libx264 -preset medium -crf 32 ${filepath_video_date}

# crf:    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
# preset: A preset is a collection of options that will provide a certain encoding speed to compression ratio. A slower preset will provide better compression (compression is quality per filesize).

time_finished=$(date +%s)

if [ "${upload_onedrive}" -eq 1 ]; then cp ${filepath_video_date} ${path_upload_onedrive}; fi


## [ Logging ] ##################################################################
cat << EOF | tee -a ${filepath_log}
  Meeri Daily:
    Size Photos: $(du -hc ${path_pictures}/${date}*.webp | tail -n1 | cut -f1)
    Size Video: $(du -h  ${filepath_video_date} | cut -f1)
    Execution time: $(( time_finished - time_start ))s
EOF
