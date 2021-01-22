#!/bin/bash
path_photos=/mnt/ramdisk/photos
interval=1

TIMEFORMAT='Duration: %Rs'

mkdir --parent "${path_photos}"

while [ -c /dev/video0 ]; do
    echo "Taking Picture ($(date +%H:%M:%S))"
    #time raspistill --rotation 270 --output "${path_photos}/buffer.jpg"
    time raspistill --rotation 270 -w 1640 -h 1232 --output "${path_photos}/buffer.jpg"
    echo "Stored in ${path_photos}/buffer.jpg"

    echo

    echo "Wait for conversion to complete."

    echo "Converting jpg to webp"
    time cwebp -quiet -q 85 ${path_photos}/buffer.jpg -o ${path_photos}/buffer.webp

    mv --force "${path_photos}/buffer.webp" "${path_photos}/current.webp"

    sleep ${interval}
    #wait
done
