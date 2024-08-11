#!/usr/bin/bash

DEVICE0=video0
DEVICE1=video2
PORT=3000

LOGITECH_DEVICE=""
OMNIVISION_DEVICE=""
#LOGITECH_NAME="Logicool Webcam C930e"
LOGITECH_NAME="C922 Pro Stream Webcam"
OMNIVISION_NAME="Laptop Integrated Webcam: Lapto"
#RUN_COMMAND=""

if [[ ! -c /dev/video0 ]]; then
    printf '%s\n' "Webcam not connected at /dev/video0 - Aborting."
    exit 1
    return
fi

VIDEO_0_NAME=`cat /sys/class/video4linux/video0/name`
VIDEO_2_NAME=""

if [[ "$VIDEO_0_NAME" == "$LOGITECH_NAME" ]]; then
    LOGITECH_DEVICE=/dev/video0
elif [[ "$VIDEO_0_NAME" == "$OMNIVISION_NAME" ]]; then
    OMNIVISION_DEVICE=/dev/video0
else
    printf '%s\n' "Unknown camera ($VIDEO_0_NAME) found at /dev/video0, aborting."
    exit 1
    return
fi

printf '%s\n' "Found $VIDEO_0_NAME at /dev/video0"

if [[ -c /dev/video2 ]]; then
    VIDEO_2_NAME=`cat /sys/class/video4linux/video2/name`

    if [[ "$VIDEO_2_NAME" == "$LOGITECH_NAME" ]]; then
        LOGITECH_DEVICE=/dev/video2
    elif [[ "$VIDEO_2_NAME" == "$OMNIVISION_NAME" ]]; then
        OMNIVISION_DEVICE=/dev/video2
    else
        printf '%s\n' "Unknown camera ($VIDEO_2_NAME) found at /dev/video2, aborting."
        exit 1
        return
    fi

    printf '%s\n' "Found $VIDEO_2_NAME at /dev/video2"
fi

#if [ ! -c /dev/$DEVICE1 ]; then
#    printf '%s\n' "Webcam $DEVICE1 is not connected! Aborting."
#    exit 1
#fi

#sudo ~/Desktop/kill-cameras.sh

#printf '%s\n' "Streaming /dev/$DEVICE0 and /dev/$DEVICE1... on 0.0.0.0:$PORT"
printf '%s' "Streaming /dev/video0 ($VIDEO_0_NAME)"

if [[ "$VIDEO_2_NAME" != "" ]]; then
    printf '%s' " and /dev/video2 ($VIDEO_2_NAME)"
fi

printf '%s\n' " on 0.0.0.0:$PORT"

APP_PATH=/home/greg/mjpg-streamer/mjpg-streamer-experimental
#RUN_COMMAND="$APP_PATH/mjpg_streamer -o \"output_http.so -w ${APP_PATH}/www -p $PORT -l 0.0.0.0\""
#RUN_COMMAND=""
LOGITECH_COMMAND=""
OMNIVISION_COMMAND=""
HAS_CAMERA=0

if [[ "$LOGITECH_DEVICE" != "" ]]; then
    LOGITECH_COMMAND="-i \"$APP_PATH/input_uvc.so -d $LOGITECH_DEVICE -r 1280x720 -timeout 30\""
    HAS_CAMERA=1
fi

if [[ "$OMNIVISION_DEVICE" != "" ]]; then
    OMNIVISION_COMMAND="-i \"$APP_PATH/input_uvc.so -d $OMNIVISION_DEVICE -r 640x480 -timeout 30\""
    HAS_CAMERA=1
fi

if [[ "$HAS_CAMERA" == "0" ]]; then
    printf '%\n' "No cameras found, not starting mjpeg streamer."
    exit 1
fi

#export LD_LIBRARY_PATH=$APP_PATH && $APP_PATH/mjpg_streamer -o "output_http.so -w ${APP_PATH}/www -p $PORT -l 0.0.0.0" -i "input_uvc.so -d -r 640x480" -i "input_uvc.so -d /dev/$DEVICE1 -r 1280x720"
# -o "output_viewer.so"

#export LD_LIBRARY_PATH=$APP_PATH && $APP_PATH/mjpg_streamer -o "output_http.so -w ${APP_PATH}/www -p $PORT -l 0.0.0.0" "${LOGITECH_COMMAND}" "${OMNIVISION_COMMAND}"
#`"$RUN_COMMAND"`

#export LD_LIBRARY_PATH=$APP_PATH && $APP_PATH/mjpg_streamer -i "input_uvc.so -d $OMNIVISION_DEVICE -r 640x480 -timeout 30" -i "input_uvc.so -d $LOGITECH_DEVICE -r 1280x720 -timeout 30" -o "output_http.so -w ${APP_PATH}/www -p $PORT -l 0.0.0.0"
#export LD_LIBRARY_PATH="$APP_PATH" && sudo $APP_PATH/mjpg_streamer "$LOGITECH_COMMAND" "$OMNIVISION_COMMAND" -o "$APP_PATH/output_http.so -w $APP_PATH/www -p $PORT -l 0.0.0.0"
export LD_LIBRARY_PATH="$APP_PATH"
LD_LIBRARY_PATH="$APP_PATH" env
LD_LIBRARY_PATH=/home/greg/mjpg-streamer/mjpg-streamer-experimental $APP_PATH/mjpg_streamer "$LOGITECH_COMMAND" "$OMNIVISION_COMMAND" -o "$APP_PATH/output_http.so -w $APP_PATH/www -p $PORT -l 0.0.0.0"
