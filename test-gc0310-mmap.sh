#!/bin/bash
set -e

FRAMES=10

FORMAT=NV12
#WIDTH=1600
#HEIGHT=1200
WIDTH=640
HEIGHT=480

#FORMAT=NV12
#WIDTH=1920
#HEIGHT=1080


./v4l2n -o testimage_@.raw \
                 --device /dev/video2 \
                 --input 1 \
                 --parm type=1,capturemode=CI_MODE_PREVIEW \
                 --fmt type=1,width=$WIDTH,height=$HEIGHT,pixelformat=$FORMAT \
                 --reqbufs count=2,memory=MMAP \
                 --parameters=wb_config.r=32768,wb_config.gr=21043,wb_config.gb=21043,wb_config.b=30863 \
                 --capture=$FRAMES

#                 --exposure=2000,0,300,0 \

for i in $(seq 0 $(($FRAMES - 1))); do
        name="testimage_$(printf "%03i" $i)"

        ./raw2pnm -x$WIDTH -y$HEIGHT -f$FORMAT $name.raw $name.pnm

        rm $name.raw
done                 
