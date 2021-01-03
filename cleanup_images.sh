#!/bin/bash

###################
#                 #
#  Images Filter  #
#                 #
###################

source $(dirname $0)/env.sh


## [ Parameters ] ##############################################################
export path_photos=${path_html_ramdisk}
export filepath_log=${filepath_log}

export filepath_data_photoSizeByTime_original=${filepath_data_photoSizeByTime_original}
export filepath_data_photoSizeByTime_filtered=${filepath_data_photoSizeByTime_filtered}
export filepath_data_photoSizeByTime=${filepath_data_photoSizeByTime}

# Minimal size in kb
# 1280x1024 webp 85%: 30kb
export clean_min_absolute_size=${clean_min_absolute_size}

# Max relative size reduction in percent
export clean_initial_expectation_percent=${clean_initial_expectation_percent}
export clean_current_expectation_percent=${clean_initial_expectation_percent}
export clean_lower_expectation_percent=${clean_lower_expectation_percent}

export debug=${clean_debug:-${debug}}
export logging=${logging}
export date=${date}


## [ Debug ] ###################################################################
if [ ${debug} -eq 1 ]; then
  mkdir --parent ${path_photos}/delete
fi


## [ Logic ] ###################################################################
time_start=$(date +%s)

# Get photo sizes before cleanup
/bin/ls -l --time-style=+"%H:%M:%S" ${path_photos}/${date}*.webp | tr -s " " "," | cut -d "," -f5,6 > ${filepath_data_photoSizeByTime_original}

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
  elif [ ${relative_size_current} -lt ${clean_current_expectation_percent} ]; then
    echo "Image discarded: (relative filesize ${relative_size_current}% < ${clean_current_expectation_percent}%)"
    if [ "$debug" -eq 1 ]; then
      mv ${file} ${path_photos}/delete
    else
      rm ${file}
    fi
    let clean_current_expectation_percent-=${clean_lower_expectation_percent}
    let count_current_expectation_failed+=1
  else
    echo "Image ok"
    clean_current_expectation_percent=${clean_initial_expectation_percent}
    absolute_size_before=${absolute_size_current}
  fi
done

# Get photo sizes after cleanup
/bin/ls -l --time-style=+"%H:%M:%S" ${path_photos}/${date}*.webp | tr -s " " "," | cut -d "," -f5,6 > ${filepath_data_photoSizeByTime_filtered}
paste --delimiters="," ${filepath_data_photoSizeByTime_original} ${filepath_data_photoSizeByTime_filtered} > ${filepath_data_photoSizeByTime}


## [ Logging ] #################################################################
time_finish=$(date +%s)

test ${logging} -eq 0 && logfile=/dev/null

cat << EOF | tee -a ${filepath_log}
$(date +"%Y-%m-%d %H:%M:%S")
  Cleanup Images:
    Deleted $((count_min_absolute_size_deleted + count_current_expectation_failed)) of ${count_files} files ($(( (count_min_absolute_size_deleted + count_current_expectation_failed) * 100 / count_files ))%)
      Absolute filesize: ${count_min_absolute_size_deleted:-0} ($(( count_min_absolute_size_deleted * 100 / count_files ))%)
      Relative filesize: ${count_current_expectation_failed:-0} ($(( count_current_expectation_failed * 100 / count_files ))%)
    Execution time: $(( time_finish - time_start ))s
EOF
