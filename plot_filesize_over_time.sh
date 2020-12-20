#!/bin/bash
clear

## [ Parameters ] ##############################################################
path_images=/var/www/html/ramdisk
path_target=/var/www/html/persistent
date=$(date +%Y%m%d)
test -n "${1}" && append="_${1}" # Use argument 1 as appendix for filename

## [ Logic ] ###################################################################
cd ${path_images}
data=$(ls -l --block-size=K --time-style=+"%H:%M:%S" $(date +%Y%m%d)*.webp | tr -s " " "," | tr -d "K" | cut -d "," -f5,6)
paste --delimiters="," <(echo "${data}" | cut -d"," -f2) <(echo "${data}" | cut -d"," -f1) > ${path_target}/$(date +%Y%m%d)${append}.csv

cat << EOF > /tmp/gnuplot_settings
  set datafile separator ','

  set xdata time          # tells gnuplot the x axis is time data
  set timefmt '%H:%M:%S'  # specify our time string format
  set format x '%H:%M:%S' # otherwise it will show only MM:SS

  set title 'Filesize over Time'
  set ylabel 'Size [kb]'
  set xlabel 'Time'

  set autoscale y
  set ytics 10
  set y2tics 10
  set xrange ['07:00:00':'18:00:00']

  set grid

  set term svg size 7000, 1000
  set output "${path_target}/$(date +%Y%m%d)${append}.svg"
  plot "${path_target}/$(date +%Y%m%d)${append}.csv" using 1:2 with dots title ''
EOF

echo ${gnuplot_settings}
gnuplot -p /tmp/gnuplot_settings
