#!/bin/bash
clear

## [ Parameters ] ##############################################################
path_images=/var/www/html/ramdisk
path_target=/var/www/html/persistent
date=$(date +%Y%m%d)
test -n "${1}" && append="_${1}" # Use argument 1 as appendix for filename

## [ Logic ] ###################################################################
cd ${path_images}
ls -l --time-style=+"%H:%M:%S" $(date +%Y%m%d)*.webp | tr -s " " "," | cut -d "," -f5,6 > ${path_target}/$(date +%Y%m%d)${append}.csv

cat << EOF > /tmp/gnuplot_settings
  set datafile separator ','

  set xdata time          # tells gnuplot the x axis is time data
  set timefmt '%H:%M:%S'  # specify our time string format
  set format x '%H:%M:%S' # otherwise it will show only MM:SS
  set format y "%.0s%cByte"

  # Labels
  set title 'Filesize over Time'
  set ylabel 'File Size'
  set xlabel 'Time'
  set label "Minimal File Size" at "7:15:00",32000 textcolor "red"

  # Axis
  set autoscale y
  set ytics 10000
  set y2tics 10000
  set xrange ['07:00:00':'18:00:00']
  set xtics '00:15:00'
  set mxtics 15

  set grid ytics xtics mxtics lt 1 lc rgb "#ee000000"

  set term svg size 7000, 1000
  set output "${path_target}/$(date +%Y%m%d)${append}.svg"

  # Styles (http://lowrank.net/gnuplot/intro/style-e.html) dots|impulses|steps|histeps|lines
  plot "${path_target}/$(date +%Y%m%d)${append}.csv" using 2:1 with histeps linecolor rgbcolor "#00aa00" title 'File Size', 30000 linecolor rgbcolor "red" title ''
EOF

gnuplot -p /tmp/gnuplot_settings
