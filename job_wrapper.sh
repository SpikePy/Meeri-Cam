#!/bin/bash
# This is just a wrapper script combining all commands that should run at the specified time via cronjob

pwd=$(dirname $0)

# Tasks
pkill fswebcam
${pwd}/cleanup_images.sh
${pwd}/plot_filesize_over_time.sh
${pwd}/daily.sh
${pwd}/archive.sh
sudo /sbin/shutdown -h 0
