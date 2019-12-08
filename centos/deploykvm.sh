#!/bin/bash

set -ex

source ../functions.sh

VERSION="8"

VERSIONNAME="1905"
CONFIG_PATH="config/$VERSION"
OSTYPE_ID="952c0bee-40d1-11e5-a7b2-0050568d6fa9"
OS_RELEASE_URL="http://ftp.tu-chemnitz.de/pub/linux/centos/8.0.1905/BaseOS/x86_64/os/"
KSFILE="anaconda-ks.cfg"
OSNAME="centos"
OSLABEL="CentOS"

PRODUCT_ARTEFACT="centos-8"

IMAGEDIR=$(pwd)"images"
mkdir -p $IMAGEDIR


deploy_vm "rhel7" "$CONFIG_PATH/$KSFILE#$CONFIG_PATH/etc/cloud/cloud.cfg" "inst.ks=file://$KSFILE"
