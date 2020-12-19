#!/bin/bash
time_start=$(date +%s)


## [ Parameters ] ##############################################################
path_photos=/var/www/html/ramdisk
path_archive=/var/www/html/persistent
filename=meeri_archive_$(date +%Y%m%d).zip


## [ Logic ] ###################################################################
zip ${path_photos}/$(date +%Y%m%d)*.webp ${path_archive}/meeri_archive_$(date +%Y%m%d).zip
time_finished1=$(date +%s)


## [ Log ] #####################################################################
cat << EOF | tee -a ${logfile}
Meeri Archive
=============
Photos archived: ${path_archive}/${filename}
Execution time: $(( time_finish - time_start ))s

EOF
