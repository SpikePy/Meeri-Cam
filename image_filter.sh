#!/bin/bash

###################
#                 #
#  Images Filter  #
#                 #
###################

echo
debug=0

## [ Parameters ] #############################################################
# Path to investigate
path=/var/www/html/ramdisk
# Image to investigate
filename=current
# Minimal size in kb
# 1280x1024 webp 85%: 30kb
min_size=30
# Max relative size reduction in percent
min_relative_size=90
# Reset relativ size after n fails
relative_size_reset_after=5


## [ Debug ] ##################################################################
if [ ${debug} -eq 1 ]; then
  echo "DEBUG ENABLED"
fi


## [ Logic ] ##################################################################
size_before=$(du ${path}/${filename}.webp 2> /dev/null | cut -f1)
size_current=$(du ${path}/${filename}.webp | cut -f1)
relative_size=$(echo "x = ${size_current} / ${size_before:=1} * 100; scale=0; x/1" | bc -l)

# Delete images with not enough detail (unsharp, to dark images)
if [ ${size_current} -lt ${min_size} ]; then
  echo "Image discarded: to small"
  rm ${path}/${filename}.webp
elif [ ${relative_size} -lt ${min_relative_size} ]; then
  echo "Image discarded: missing details"
  rm ${path}/${filename}.webp
  let relative_size_reset_after=${relative_size_reset_after}+1
else
  relative_size_reset_after=0
fi





echo
echo
