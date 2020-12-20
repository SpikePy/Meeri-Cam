#!/bin/bash
# This is just a wrapper script combining all commands that should run at the specified time via cronjob

kill $(pgrep -o fswebcam) || true
$HOME/Meeri-Cam/plot_filesize_over_time.sh dirty
$HOME/Meeri-Cam/cleanup_images.sh
$HOME/Meeri-Cam/plot_filesize_over_time.sh clean
$HOME/Meeri-Cam/meeri_daily.sh
$HOME/Meeri-Cam/meeri_archive.sh
sudo /sbin/shutdown -h now
