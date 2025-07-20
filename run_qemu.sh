#!/usr/bin/env zsh

# brew install qemu
FILE_DIR="./kernel_file"
IMG="${FILE_DIR}/2025-05-13-raspios-bookworm-arm64-lite.qcow2"
if [[ ! -f "${IMG}" ]]; then
  echo "Image file not found: ${IMG}"
  exit 1
fi

echo "Starting QEMU with image: ${IMG}"
qemu-system-aarch64 -M virt \
-cpu cortex-a72 \
-smp 2 \
-m 2G \
-kernel "${FILE_DIR}/Image" \
-drive if=none,file="${IMG}",id=rootfs,format=qcow2 \
-device virtio-blk-pci,drive=rootfs \
-append "console=ttyAMA0 root=/dev/vda2 rw earlyprintk=serial,ttyAMA0 kgdboc=ttyAMA0,115200 kgdbwait" \
-nographic 
