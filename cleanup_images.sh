#!/bin/bash

###################
#                 #
#  Images Filter  #
#                 #
###################

source ~/Meeri-Cam/env
clear


## [ Parameters ] ##############################################################
path_photos=${path_html_ramdisk}
path_log=${path_log}

filepath_data_photoSizeByTime_dirty=${filepath_data_photoSizeByTime_dirty}
filepath_data_photoSizeByTime_clean=${filepath_data_photoSizeByTime_clean}
filepath_data_photoSizeByTime=${filepath_data_photoSizeByTime}

# Minimal size in kb
# 1280x1024 webp 85%: 30kb
clean_min_absolute_size=${clean_min_absolute_size}

# Max relative size reduction in percent
clean_min_relative_size=${clean_min_relative_size}

# Reset relativ size after n fails
clean_relative_size_reset_after=${clean_relative_size_reset_after}

debug=0
logging=${logging}
date=${date}


## [ Debug ] ###################################################################
if [ ${debug} -eq 1 ]; then
  echo " ######################"
  echo " # DEBUG MODE ENABLED #"
  echo " ######################"
  echo
  mkdir -p ${path_photos}/delete
fi


## [ Logic ] ###################################################################
local time_start=$(date +%s)

# Get photo sizes before cleanup
/bin/ls -l --time-style=+"%H:%M:%S" ${path_photos}/${date}*.webp | tr -s " " "," | cut -d "," -f5,6 > ${filepath_data_photoSizeByTime_dirty}

for file in $(/bin/ls -1 ${path_photos}/${date}*.webp); do
  let count_files+=1
  echo -n "${file}: "
  absolute_size_current=$(du ${file} | cut -f1)
  #relative_size_current=$(echo "x = ${absolute_size_current} / ${absolute_size_before:=1} * 100; scale=0; x/1" | bc -l)
  relative_size_current=$(( absolute_size_current * 100 / ${absolute_size_before:=1} ))

  # Delete images with not enough detail (unsharp/to dark)
  if [ ${absolute_size_current} -lt ${clean_min_absolute_size} ]; then
    echo "Image discarded (absolute filesize ${absolute_size_current}k < ${clean_min_absolute_size}k)"
    if [ "${debug}" -eq 1 ]; then
      mv ${file} ${path_photos}/delete
    else
      rm ${file}
    fi
    let count_min_absolute_size_deleted+=1
  elif [ ${relative_size_current} -lt ${clean_min_relative_size} ]; then
    echo "Image discarded: (relative filesize ${relative_size_current}% < ${clean_min_relative_size}%)"
    if [ "$debug" -eq 1 ]; then
      mv ${file} ${path_photos}/delete
    else
      rm ${file}
    fi
    let count_min_relative_size_deleted+=1
    let count_consecutive_relative_size_failed+=1
  else
    echo "Image ok"
    relative_size_failed=0
    absolute_size_before=${absolute_size_current}
  fi

  if [ ${count_consecutive_relative_size_failed:=0} -ge ${clean_relative_size_reset_after} ]; then
    echo "  Reset base size"
    absolute_size_before=${absolute_size_current}
  fi
done

# Get photo sizes after cleanup
/bin/ls -l --time-style=+"%H:%M:%S" ${path_photos}/${date}*.webp | tr -s " " "," | cut -d "," -f5,6 > ${filepath_data_photoSizeByTime_clean}
paste --delimiters="," ${filepath_data_photoSizeByTime_dirty} ${filepath_data_photoSizeByTime_clean} > ${filepath_data_photoSizeByTime}


## [ Logging ] #################################################################
local time_finish=$(date +%s)

test ${logging} -eq 0 && logfile=/dev/null

cat << EOF | tee -a ${path_log}
$(date +"%Y-%m-%d %H:%M:%S")
  Cleanup Images:
    Deleted $((count_min_absolute_size_deleted + count_min_relative_size_deleted)) of ${count_files} files ($(( (count_min_absolute_size_deleted + count_min_relative_size_deleted) * 100 / count_files ))%)
      Absolute filesize: ${count_min_absolute_size_deleted:-0}
      Relative filesize: ${count_min_relative_size_deleted:-0}
    Execution time: $(( time_finish - time_start ))s
EOF
