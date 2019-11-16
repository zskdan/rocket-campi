#!/bin/bash - 
mkdir -p dl
mkdir -p work
mkdir -p work/mountpoint

[ $# -lt 1 ] && exit

URL=https://downloads.raspberrypi.org/raspbian_latest
IMAGE_FILE=raspbian-buster.zip
sdcardnode=$1

#1. download latest image
cd dl
  [ -f $IMAGE_FILE ] || wget $URL -O $IMAGE_FILE 
cd ..

#2. modify the image 
cd work
  unzip ../dl/$IMAGE_FILE
  mkdir mountpoint -p
  mv *.img rasbian.img
  sudo partx -a -v raspbian.img
  loopdev=$(losetup -j raspbian.img | cut -f1 -d:)
  sudo mount $loopdev mountpoint/

  sudo bash -c 'echo "dtoverlay=dwc2" >>  mountpoint/config.txt'
  sudo sed -i '$s/$/ modules-load=dwc2,g_ether/' mountpoint/cmdline.txt 
  sudo touch mountpoint/ssh

  sudo umount $loopdev 
  sudo partx -d -v $loopdev 
  sudo losetup -d $loopdev
cd ..

# 3. write the image
sudo dd if=raspbian.img of=$sdcardnode
sudo watch progress
