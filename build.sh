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

  sudo mount ${loopdev}p1 mountpoint/
    sudo bash -c 'echo "dtoverlay=dwc2" >>  mountpoint/config.txt'
    sudo bash -c 'echo "start_x=1" >>  mountpoint/config.txt'
    sudo bash -c 'echo "gpu_mem=128" >>  mountpoint/config.txt'
    sudo sed -i '$s/$/ modules-load=dwc2,g_ether/' mountpoint/cmdline.txt
    sudo touch mountpoint/ssh
  sudo umount ${loopdev}p1

  sudo mount ${loopdev}p2 mountpoint/
    sudo mkdir -p mountpoint/home/pi/work
    sudo cp script-video/stream.sh mountpoint/home/pi/work
    sudo chown -R 1000:1000 mountpoint/home/pi/work
    sudo dpkg -i --force-architecture --force-depends  --root=$PWD/mountpoint --admindir=$PWD/mountpoint/var/lib/dpkg ../dl/libgstreamer1.0-0_1.14.4-1_armhf.deb ../dl/gstreamer1.0-tools_1.14.4-1_armhf.deb
  sudo umount ${loopdev}p2

  sudo partx -d -v $loopdev
  sudo losetup -d $loopdev
cd ..

# 3. write the image
sudo dd if=raspbian.img of=$sdcardnode
sudo watch progress
