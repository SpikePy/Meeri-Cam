#!/bin/bash

cd /var/www/html/ramdisk/
clear

# Analyze images
count_files=$(ls -1 [0-9]*.webp | wc -l)
count_deleted=0
time \
for file in $(/bin/ls [0-9]*.webp); do
  # Analyse image with imagemagick and store mean and standard-deviation in a variable
  # separate values with "." so we can easyly parse the integers for further actions
  analysis=$(identify -format "%[fx:100*mean].%[standard-deviation]" $file  | cut -d"." -f1)
  echo -n "$file: "

  # Sort out dark images
  mean=$(echo "$analysis"  | cut -d"." -f1)
  if [ ${mean} -ge 5 ]; then
    echo -n "Image ok"
  else
    echo -n "Image to dark"
    rm $file
    let count_deleted+=1
  fi
  echo " (mean=$mean)"

#  # Sort out unsharp images
#  standard_deviation=$(echo "$analysis"  | cut -d"." -f3)
#  echo "$standard_deviation_before / ${standard_deviation_before:=$standard_deviation}" | bc -l
#  if []; then
#
#
#  else
#
#  fi
#
#  echo " (standard_deviation_ratio=...)"
done
echo "Deleted $count_deleted of $count_files files."
