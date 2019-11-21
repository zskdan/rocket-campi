#!/bin/bash - 
#===============================================================================
#
#          FILE:  compo1.0.sh
# 
#         USAGE:  ./compo1.0.sh 
# 
#   DESCRIPTION:  i
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (zskdan), zakaria@elqotbi.com
#       VERSION:  1.0
#       CREATED:  15/02/2018 00:59:04 CET
#      REVISION:  ---
#===============================================================================

# To play the resulted video:
# $ gst-launch-1.0 filesrc location=out.mp4 ! decodebin ! videoconvert! autovideosink

#framerate=30
framerate=25

gsink_z=0
gsink_h=1080
gsink_w=1920

sink_z=10
sink_h=$[gsink_h/2]
sink_w=$[gsink_w/2]

#OUTPUT="videoconvert ! autovideosink"
#OUTPUT="jpegenc ! avimux ! filesink location=out.avi"
#OUTPUT="x264enc pass=quant ! matroskamux ! filesink location=out.mkv"
#OUTPUT="x264enc pass=5 quantizer=25 speed-preset=6 ! video/x-h264, profile=baseline ! mp4mux ! filesink location=out.mp4"
#OUTPUT="fakesink sync=false"
OUTPUT="fakevideosink"

#LIMITE_BUFFER=""
LIMITE_BUFFER="num-buffers=1000"

#PROFILER=""
PROFILER=gst-top-1.0

$PROFILER gst-launch-1.0 -e videomixer name=mix sink_0::zorder=$sink_z sink_1::zorder=$sink_z sink_2::zorder=$sink_z sink_3::zorder=$sink_z sink_4::zorder=$gsink_z ! \
    $OUTPUT \
    videotestsrc $LIMITE_BUFFER pattern=1  ! video/x-raw,framerate=${framerate}/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=0          left=0          ! mix. \
    videotestsrc $LIMITE_BUFFER pattern=15 ! video/x-raw,framerate=${framerate}/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=0          left=-${sink_w} ! mix. \
    videotestsrc $LIMITE_BUFFER pattern=13 ! video/x-raw,framerate=${framerate}/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=-${sink_h} left=0          ! mix. \
    videotestsrc $LIMITE_BUFFER  pattern=0 ! video/x-raw,framerate=${framerate}/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=-${sink_h} left=-${sink_w} ! mix.
