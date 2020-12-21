#!/bin/bash
source ~/Meeri-Cam/env
clear


## [ Parameters ] ##############################################################
date=${date}
filepath_data=${filepath_data_photoSizeByTime}
filepath_plot=${path_html_persistent}/${date}.svg


## [ Logic ] ###################################################################
cat << EOF > /tmp/gnuplot_settings
  set datafile separator ','

  set xdata time          # tells gnuplot the x axis is time data
  set timefmt '%H:%M:%S'  # specify our time string format
  set format x '%H:%M:%S' # otherwise it will show only MM:SS
  set format y "%.0s%cByte"
  set format y2 "%.0s%cByte"

  # Labels
  set title 'Filesize over Time'
  set ylabel 'File Size'
  set xlabel 'Time'
  set label "Minimal File Size" at "7:15:00",32000 textcolor "red"
  set label "Minimal File Size" at "17:36:00",32000 textcolor "red"

  # Axis
  set autoscale y
  set ytics 10000
  set y2tics 10000
  #set xrange ['07:00:00':'18:00:00']
  set xtics '00:15:00'
  set mxtics 15

  set grid ytics xtics mxtics lt 1 lc rgb "#ee000000"

  set term svg size 7000, 1000
  set output "${filepath_plot}"

  # Styles (http://lowrank.net/gnuplot/intro/style-e.html) dots|impulses|steps|histeps|lines
  set key left
  plot "${filepath_data}" using 2:1 with histeps linecolor rgbcolor "#aa8100" title 'Dirty', \
       "${filepath_data}" using 4:3 with histeps linecolor rgbcolor "#00aa00" title 'Clean', \
        30000 linecolor rgbcolor "red" notitle
EOF

gnuplot -p /tmp/gnuplot_settings
