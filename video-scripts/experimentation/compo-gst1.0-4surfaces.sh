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

gsink_z=0
gsink_h=1080
gsink_w=1920

sink_z=10
sink_h=$[gsink_h/2]
sink_w=$[gsink_w/2]

gst-launch-1.0 videomixer name=mix sink_0::zorder=$sink_z sink_1::zorder=$sink_z sink_2::zorder=$sink_z sink_3::zorder=$sink_z sink_4::zorder=$gsink_z ! \
    videoconvert ! autovideosink \
    videotestsrc pattern=1  ! video/x-raw,framerate=30/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=0          left=0          ! mix. \
    videotestsrc pattern=15 ! video/x-raw,framerate=30/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=0          left=-${sink_w} ! mix. \
    videotestsrc pattern=13 ! video/x-raw,framerate=30/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=-${sink_h} left=0          ! mix. \
    videotestsrc pattern=0  ! video/x-raw,framerate=30/1,width=${sink_w},height=${sink_h} ! videobox border-alpha=0 top=-${sink_h} left=-${sink_w} ! mix.
