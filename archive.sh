#!/bin/bash
source $(dirname $0)/env


## [ Parameters ] ##############################################################
path_html_ramdisk=${path_html_ramdisk}
path_html_archive=${path_html_archive}
path_log=${path_log}

## [ Logic ] ###################################################################
local time_start=$(date +%s)

mkdir -p ${path_html_archive}

mv ${path_html_ramdisk}/${date}* ${path_html_archive}

local time_finished1=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${path_log}
  Meeri Archive:
    Path: ${path_html_archive}
    Files:  $(/bin/ls -1 | wc -l)
    Size: $(du -h ${path_html_archive} | cut -f1)
    Execution time: $(( time_finish - time_start ))s
EOF
