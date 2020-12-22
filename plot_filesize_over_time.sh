#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] ##############################################################
export date=${date}
export filepath_data=${filepath_data_photoSizeByTime}
export filepath_plot=${path_html_persistent}/${date}_${clean_initial_expectation_percent}_${clean_lower_expectation_percent}.svg


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
  plot "${filepath_data}" using 4:3 with histeps linecolor rgbcolor "#0000aa00" title "Initial expectation ${clean_initial_expectation_percent}%, lower expectation by ${clean_lower_expectation_percent}%", \
       "${filepath_data}" using 2:1 with histeps linecolor rgbcolor "#cc00aa00" title "Original", \
        30000 linecolor rgbcolor "red" title "Minimal File Size"
EOF

gnuplot -p /tmp/gnuplot_settings
