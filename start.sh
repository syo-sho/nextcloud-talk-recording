#!/bin/bash

# Variables
if [ -z "$NC_DOMAIN" ]; then
    echo "You need to provide the NC_DOMAIN."
    exit 1
elif [ -z "$RECORDING_SECRET" ]; then
    echo "You need to provide the RECORDING_SECRET."
    exit 1
elif [ -z "$INTERNAL_SECRET" ]; then
    echo "You need to provide the INTERNAL_SECRET."
    exit 1
fi

if [ -z "$HPB_DOMAIN" ]; then
    export HPB_DOMAIN="$NC_DOMAIN"
fi

# Delete all contents on startup to start fresh
rm -rf /tmp/* 2>/dev/null

cat << RECORDING_CONF > "/conf/recording.conf"
[logs]
# 30 means Warning
level = 30

[http]
listen = 0.0.0.0:1234

[backend]
allowall = ${ALLOW_ALL}
# The secret below is still needed if allowall is set to true, also it doesn't hurt to be here
secret = ${RECORDING_SECRET}
backends = backend-1
skipverify = ${SKIP_VERIFY}
maxmessagesize = 1024
videowidth = 960
videoheight = 540
directory = /tmp

[backend-1]
url = ${NC_PROTOCOL}://${NC_DOMAIN}
secret = ${RECORDING_SECRET}
skipverify = ${SKIP_VERIFY}

[signaling]
signalings = signaling-1

[signaling-1]
url = ${HPB_PROTOCOL}://${HPB_DOMAIN}${HPB_PATH}
internalsecret = ${INTERNAL_SECRET}

[ffmpeg]
# common = ffmpeg -loglevel level+warning -n
# outputaudio = -c:a libopus -b:a 32k
# outputvideo = -c:v libvpx -deadline:v realtime -cpu-used 8 -crf 32 -b:v 800k
common = ffmpeg -loglevel warning -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi
outputaudio = -c:a libopus -b:a 32k
outputvideo = -vf "hwupload,format=vaapi" -c:v h264_vaapi -profile:v main -level 4.0 -b:v 2M -maxrate 2M -bufsize 4M
extensionaudio = .ogg
extensionvideo = .webm

[recording]
browser = firefox
driverPath = /usr/bin/geckodriver
browserPath = /usr/bin/firefox
browserArgs = --headless
RECORDING_CONF

exec "$@"
