#!/bin/bash

###################
#                 #
#  Images Filter  #
#                 #
###################

echo
debug=1

## [ Parameters ] #############################################################
# Path to investigate
path=/var/www/html/ramdisk
# Image to investigate
filename=current.jpg
# Minimal size in kb
min_size=950
# Max relative size reduction in percent
max_rel_size_reduction=7
# Reset relativ size after n fails
reset_rel_size_after=6


## [ Debug ] ##################################################################
if [ ${debug} -eq 1 ]; then
  echo "DEBUG ENABLED"
  echo "Generate timestamped JPEG for further analysis: ${path}/debug/$(date +%Y%m%d_%H%M%S).jpg"
  mkdir -p ${path}/debug
  cp ${path}/${filename} ${path}/debug/$(date +%Y%m%d_%H%M%S).jpg
fi


## [ Logic ] ##################################################################
# Delete images with not enough detail (unsharp, to dark images)
if [ $(du ${path}/${filename} | cut -f1) -lt ${min_size} ]; then
  echo "Image discarded: to small"
  rm ${path}/${filename}
fi




echo
echo
