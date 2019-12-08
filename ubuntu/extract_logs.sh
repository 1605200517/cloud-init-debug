#!/bin/bash

diskfile=$1
diskfile="/ubuntu-bionic.qcow2"

mkdir -p /mnt/$diskfile/
mkdir -p logs
mnt="/mnt/$diskfile/"


modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 $diskfile
# mount first partition
mount /dev/nbd0p1 $mnt

ls -alh $mnt/root
cp $mnt/root/*.gz logs/
cp $mnt/var/log/ logs/ -R
umount $mnt
qemu-nbd --disconnect /dev/nbd0
rm -Rf /mnt/$diskfile/
