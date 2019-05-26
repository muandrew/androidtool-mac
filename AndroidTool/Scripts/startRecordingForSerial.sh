#!/bin/sh

#  startrecording.sh
#  Bugs
#
#  Created by Morten Just Petersen on 4/10/15.
#  Copyright (c) 2015 Morten Just Petersen. All rights reserved.

dir=$(dirname "$0")
source $dir/androidtool_prefix.sh
thisdir=$1 # $1 is the bundle resources path directly from the calling script file
serial=$2
width=$3
height=$4
bitrate=$5

chara=$($adb -s $serial shell getprop ro.build.characteristics)
if [[ $chara == *"watch"* ]]
then
    echo "Recording from watch..."
    # Get resolution if no custom res was specified
    if [[ ! $width ]]
    then
        width=`"$adb" -s $serial shell dumpsys display | grep mDisplayWidth | awk -F '=' '{ print $2 }' | tr -d '\r\n'`
    fi
    if [[ ! $height ]]
    then
        height=`"$adb" -s $serial shell dumpsys display | grep mDisplayHeight | awk -F '=' '{ print $2 }' | tr -d '\r\n'`
    fi
    sizeopt=""
    # Put a --size option only if both params are available
    if [[ $width && $height ]]
    then
        sizeopt=${width}x${height}
    fi

    "$adb" -s $serial shell screenrecord --size $sizeopt --o raw-frames /sdcard/screencapture.raw
else
    echo "Recording from phone..."
    
    orientation=$("$adb" -s $serial shell dumpsys input | grep 'SurfaceOrientation' | awk '{ print $2 }')

    sizeopt=""
    if [[ "${orientation//[$'\t\r\n ']}" != "0" ]]
    then
        sizeopt="--size ${height}x${width}"
    else
        sizeopt="--size ${width}x${height}"
    fi
    
    "$adb" -s $serial shell screenrecord --verbose --bit-rate $bitrate ${sizeopt} /sdcard/capture.mp4  # > $1/reclog.txt
    
    ## [bugre] UMI Max with Android 7, is 1920x1080 device, but recording setting this resolution
    ## results in error. Must be: 1920x1088 or let it record without resolution defined.
    ## Maybe this error also afects some other devices. 
    if [ "$ret" != "0" ]; then
        echo "Trying again, but now without setting the resolution."
        "$adb" -s $serial shell screenrecord --verbose --bit-rate $bitrate /sdcard/capture.mp4  # > $1/reclog.txt
    fi
fi