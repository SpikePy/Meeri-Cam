#!/bin/bash

# This file is meant to be sourced by the other scripts to get a single point of truth
date=$(\date +%Y%m%d)
logging=1
debug=1

path_html_root=/var/www/spikepy.v6.rocks
path_html_ramdisk=${path_html_root}/ramdisk
path_html_persistent=${path_html_root}/persistent
path_html_archive=${path_html_persistent}/${date}
path_thumbnails=${path_html_ramdisk}/thumbnails
path_upload_onedrive=~/OneDrive/Meeri-Cam
path_debug=${path_html_ramdisk}/debug

filename_photo_latest=current.webp

filepath_log=~/meeri.log
filepath_data_photoSizeByTime_original=/tmp/meeri_photo_sizeByTime_${date}_original.csv
filepath_data_photoSizeByTime_filtered=/tmp/meeri_photo_sizeByTime_${date}_filtered.csv
filepath_data_photoSizeByTime=${path_html_persistent}/meeri_photo_sizeByTime_${date}.csv
filepath_video_date=${path_html_persistent}/meeri_daily_${date}.mp4

photo_intervall=10
photo_combine_frames=20
photo_frames_per_second=10
photo_quality=95

clean_min_absolute_size=40
clean_initial_expectation_percent=98
clean_lower_expectation_percent=2

video_crf=32
upload_onedrive=1

light_gpio_pin=17
light_photo_filepath=/tmp/${filename_photo_latest}
light_switch_photoSize=10
light_switch_treshold_exceetions=5


mkdir --parent ${path_debug} ${path_thumbnails}
