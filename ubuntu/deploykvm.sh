#!/bin/sh

set -ex

CONFIG_PATH="config/18.04"
PRODUCT_ARTEFACT="ubuntu-bionic"
VERSIONNAME="bionic"
OS_RELEASE_URL="http://ftp.halifax.rwth-aachen.de/ubuntu/dists/$VERSIONNAME/main/installer-amd64/"

mkdir -p $(pwd)/images/
IMAGEDIR="images"

virt-install --debug --wait -1 --force --noreboot --noautoconsole \
         --graphics vnc,password=password --virt-type=kvm --hvm \
         --disk=$IMAGEDIR/${PRODUCT_ARTEFACT}.qcow2,format=qcow2,size=10 \
         --os-type=linux --os-variant debianwheezy --memory 4096 --vcpus=2 \
         --location=${OS_RELEASE_URL} \
         --network network=default \
         --console pty,target_type=serial \
         --initrd-inject $CONFIG_PATH/preseed.cfg \
         --initrd-inject $CONFIG_PATH/ubuntu-sysprep.sh \
         --initrd-inject $CONFIG_PATH/etc/cloud/cloud.cfg \
         --extra-args="console=ttyS0,115200n8 serial vga=normal fb=false auto=true interface=eth0 \
                        biosdevname=0 net.ifnames=0 \
                        file=/preseed.cfg priority=critical" \
          --name=${PRODUCT_ARTEFACT}

virsh destroy $PRODUCT_ARTEFACT
