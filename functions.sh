#!/bin/bash

function deploy_vm(){

  virt-install --version

  osvariant=$1
  initrdinject=$2
  extraargs=$3

  IFS='#' # set delimiter
  injectlines=""
  read -ra INJECTS <<< "$initrdinject" # str is read into an array as tokens separated by IFS
  for i in "${INJECTS[@]}"; do
    injectlines="${injectlines} --initrd-inject \"$i\" "
  done
  IFS=' ' # reset to default value after usage


  cmd="virt-install --wait -1 --force \
      --noreboot --noautoconsole --graphics \
      vnc --virt-type=kvm --hvm \
      --disk=\"$IMAGE_DIR/$PRODUCT_ARTEFACT.qcow2,format=qcow2,size=10,bus=virtio\" \
      --os-type=linux --os-variant=\"$osvariant\" -r 8192 \
      --vcpus=2 --location=\"$OS_RELEASE_URL\" \
      --network network=default \
      --name=\"$PRODUCT_ARTEFACT\" \
      $injectlines \
      --extra-args \"$extraargs\""
  eval $cmd

}

