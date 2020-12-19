#!/bin/bash

###################
#                 #
#  Images Filter  #
#                 #
###################

clear
debug=0

## [ Parameters ] ##############################################################
# Path to investigate
path=/var/www/html/ramdisk
# Minimal size in kb
# 1280x1024 webp 85%: 30kb
min_size=30
# Max relative size reduction in percent
min_relative_size=75
# Reset relativ size after n fails
relative_size_reset_after=5

## [ Set Initial Values ]#######################################################
count_files=$(/bin/ls -1 ${path}/[0-9]*.webp | wc -l)


## [ Debug ] ###################################################################
if [ ${debug} -eq 1 ]; then
  echo "DEBUG ENABLED"
  mkdir -p ${path}/delete
fi


## [ Logic ] ###################################################################
time \
for file in $(/bin/ls -1 ${path}/[0-9]*.webp); do
  echo -n "${file}: "
  size_current=$(du ${file} | cut -f1)
  relative_size=$(echo "x = ${size_current} / ${size_before:=1} * 100; scale=0; x/1" | bc -l)

  # Delete images with not enough detail (unsharp/to dark)
  if [ ${size_current} -lt ${min_size} ]; then
    echo "Image discarded (absolute filesize ${size_current}k < ${min_size}k)"
    if [ "${debug}" -eq 1 ]; then
      mv ${file} ${path}/delete
    else
      rm ${file}
    fi
    let count_deleted_min_size+=1
  elif [ ${relative_size} -lt ${min_relative_size} ]; then
    echo "Image discarded: (relative filesize ${relative_size}% < ${min_relative_size}%)"
    if [ "$debug" -eq 1 ]; then
      mv ${file} ${path}/delete
    else
      rm ${file}
    fi
    let count_deleted_min_relative_size+=1
    let relative_size_failed=${relative_size_failed}+1
  else
    echo "Image ok"
    relative_size_failed=0
    size_before=${size_current}
  fi

  if [ ${relative_size_failed:=0} -ge ${relative_size_reset_after} ]; then
    echo "Reset base size"
    size_before=${size_current}
  fi
done
echo "Deleted $((count_deleted_min_size + count_deleted_min_relative_size)) of ${count_files} files"
echo "Absolute filesize: ${count_deleted_min_size:=0}"
echo "Relative filesize: ${count_deleted_min_relative_size:=0}"
