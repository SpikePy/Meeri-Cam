#!/bin/bash
time_start=$(date +%s)


## [ Parameters ] ##############################################################
path_photos=/var/www/html/ramdisk
path_archive=/var/www/html/persistent/$(date +%Y%m%d)


## [ Logic ] ###################################################################
mkdir -p ${path_archive}
mv ${path_photos}/$(date +%Y%m%d)* ${path_archive}
time_finished1=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${logfile}
Meeri Archive
=============
Photos archived: ${path_archive}/${filename}
Execution time: $(( time_finish - time_start ))s

EOF
