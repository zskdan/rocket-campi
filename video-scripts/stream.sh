#!/bin/bash - 
#===============================================================================
#
#          FILE:  stream.sh
# 
#         USAGE:  ./stream.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (zskdan), zakaria@elqotbi.com
#       VERSION:  1.0
#       CREATED:  07/04/2018 12:23:59 CEST
#      REVISION:  ---
#===============================================================================

destip=$1
destport=${2:-9000}

[ -z "$destip" ] && {
	echo "destination IP address not specified!"
	echo " Usage:    $0 DESTIP [DESTPORT]"
	echo "    ex:    $0 192.168.0.20 9000"
	exit
}

raspivid -n -w 1280 -h 720 -b 4500000 -fps 25 -vf -hf -t 0 -o - | gst-launch-1.0 -v fdsrc !  h264parse ! rtph264pay config-interval=10 pt=96 ! udpsink host=$destip port=$destport
