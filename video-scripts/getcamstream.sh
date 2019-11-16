#!/bin/bash - 
#===============================================================================
#
#          FILE:  getcamstream.sh
# 
#         USAGE:  ./getcamstream.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (zskdan), zakaria@elqotbi.com
#       VERSION:  1.0
#       CREATED:  07/04/2018 12:21:07 CEST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

port=${1:-9000}

gst-launch-1.0 -v udpsrc port=$port caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' ! rtph264depay ! avdec_h264 ! videoconvert ! autovideosink sync=false
