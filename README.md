# Meeri-Cam

1. install webp fswebcam lighttpd `sudo apt install webp fswebcam lighttpd`
2. add 'mimetype.assign   += ( ".webp" => "image/webp" )' to /etc/lighttpd/lighttpd.conf to make browser show webp images
3. create a ramdisk to write images to, to  go easy on sd-card
4. enable dir listing
5. `ln -f index.html /var/www/html/`

```
fswebcam \
  --resolution 1280x1024 \
  --no-banner \
  --frames 20 \
  --jpeg 95 \
  --loop 15 \
  --save /var/www/html/ramdisk/cam.jpg \
  --exec 'cwebp -q 85 /var/www/html/ramdisk/cam.jpg -o /var/www/html/ramdisk/cam.webp; cp /var/www/html/ramdisk/cam.webp /var/www/html/ramdisk/$(date +%Y%m%d_%H%M%S)_cam.webp'
```

```
# --set options
Available Controls        Current Value   Range
------------------        -------------   -----
Brightness                255 (100%)      0 - 255
Contrast                  32 (12%)        0 - 255
Saturation                31 (12%)        0 - 255
White Balance Temperature, Auto True      True | False
Gain                      127 (49%)       0 - 255
Power Line Frequency      60 Hz           Disabled | 50 Hz | 60 Hz
White Balance Temperature 1180 (11%)      0 - 10000
Sharpness                 130 (50%)       0 - 255
Backlight Compensation    1               0 - 1
Exposure, Auto            Aperture Priority Mode Manual Mode | Aperture Priority Mode
Exposure (Absolute)       155 (1%)        1 - 10000
Exposure, Auto Priority   True            True | False
Privacy                   False           True | False
```

# Crontab
Automatically run the script in the correct order by creating these cronjobs

```
@reboot     $HOME/Meeri-Cam/light.sh
@reboot     $HOME/Meeri-Cam/capture.sh
0  22 * * * $HOME/Meeri-Cam/job_wrapper.sh
```
# Setup OneDrive via rclone
to upload photos/videos

## Mount Onedrive on Startup vis systemd

vim ~/.config/systemd/user/onedrive.service
```ini
[Unit]
Description=OneDrive (rclone)
Documentation=https://gist.github.com/rolfn/4e9d373bb690adc7b1a8717d853190c1#synchronisieren-eines-lokalen-verzeichnisses-mit-dem-online-speichers

[Service]
Type=simple
ExecStart=/usr/bin/rclone --config %h/.config/rclone/rclone.conf --vfs-cache-mode writes mount onedrive:/Meeri-Cam %h/OneDrive/Meeri-Cam
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

vim ~/.config/systemd/user/onedrive.timer
```ini
[Unit]
Description=Onedrive rclone (Timer)
Documentation=https://rclone.org/docs/

[Timer]
OnActiveSec=20
OnUnitInactiveSec=600

[Install]
WantedBy=default.target
```

# Create SMB Shares
Setup SMB-Shares to easily acccess and develop the project from another system.

/etc/samba/smb.conf
```ini

[global]
workgroup = WORKGROUP
log file = /var/log/samba/log.%m
max log size = 1000
logging = file
map to guest = bad user

[meeri_cam]
browseable = yes
path = /var/www/html
guest ok = yes
read only = no
create mask = 777

[meeri_project]
path = /home/pi/Meeri-Cam
browseable = yes
guest ok = yes
force user = pi
read only = no
directory mask = 2775
force directory mode = 2775
directory security mask = 2775
force directory security mode = 2775
```
