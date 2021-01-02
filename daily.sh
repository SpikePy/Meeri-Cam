#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] ##############################################################
path_pictures=${path_html_ramdisk}
path_video=${path_html_persistent}
filepath_video_date=${filepath_video_date}
filepath_log=${filepath_log}
upload_onedrive=${upload_onedrive}
path_upload_onedrive=${path_upload_onedrive}
date=${date}
video_crf=${video_crf}


## [ Logic ] ###################################################################
time_start=$(date +%s)
cd ${path_pictures}

# Convert images to video (https://trac.ffmpeg.org/wiki/Encode/H.264)
# preset: A preset is a collection of options that will provide a certain encoding speed to compression ratio. A slower preset will provide better compression (compression is quality per filesize).
# crf:    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
time ffmpeg -y -r 10 -pattern_type glob -i "${date}*.webp" -c:v libx264 -preset medium -crf ${video_crf} ${filepath_video_date}
time_finish=$(date +%s)


## [ Logging ] #################################################################
cat << EOF | tee -a ${filepath_log}
  Daily Summary Video:
    Size Photos: $(du -hc ${path_pictures}/${date}*.webp | tail -n1 | cut -f1)
    Size Video: $(du -h  ${filepath_video_date} | cut -f1)
    Execution time: $(( time_finish - time_start ))s
EOF


## [ Upload ] ##################################################################
if [ ${upload_onedrive:-0} -eq 1 ]; then
  systemctl --user start rclone.service

  while [ "$(systemctl --user is-active rclone.service)" != "active" ]; do
    let try+=1
    sleep 3
    if [ ${try:=0} -ge 5 ]; then 
      echo "OneDrive not mounted" | tee -a ${filepath_log}
      exit 1
    fi
  done

  echo "Upload video to OneDrive" | tee -a ${filepath_log}
  cp ${filepath_video_date} ${path_upload_onedrive}

  systemctl --user stop rclone.service
fi
