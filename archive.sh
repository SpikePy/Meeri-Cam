#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] ##############################################################
export date=${date}
export path_photos=${path_html_ramdisk}
export path_html_archive=${path_html_archive}
export filepath_log=${filepath_log}

## [ Logic ] ###################################################################
time_start=$(date +%s)

mkdir -p ${path_html_archive}

mv ${path_photos}/${date}* ${path_html_archive}

time_finished=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${filepath_log}
  Meeri Archive:
    Path: ${path_html_archive}
    Files:  $(/bin/ls -1 | wc -l)
    Size: $(du -h ${path_html_archive} | cut -f1)
    Execution time: $(( time_finish - time_start ))s
EOF
