#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] ##############################################################
date=${date}
path_photos=${path_html_ramdisk}
path_html_archive=${path_html_archive}
filepath_log=${filepath_log}

## [ Logic ] ###################################################################
time_start=$(date +%s)

mkdir -p ${path_html_archive}

mv ${path_photos}/${date}* ${path_html_archive}

time_finish=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${filepath_log}
  Meeri Archive:
    Path: ${path_html_archive}
    Files:  $(/bin/ls -r1 | wc -l)
    Size: $(du -h ${path_html_archive} | cut -f1)
    Execution time: $(( time_finish - time_start ))s
EOF
