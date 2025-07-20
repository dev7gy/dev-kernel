#!/usr/bin/env bash
set -e
# get source
if [[ ! -d linux ]]; then
	wget -O linux.tar.gz https://github.com/raspberrypi/linux/archive/refs/tags/stable_20250702.tar.gz
	tar xvfz ./linux.tar.gz
	mv linux-stable* linux
fi

cd linux
# set git remote
BUILD_OUTPUT_DIR="${PWD}/build"
BUILD_LOG="${BUILD_OUTPUT_DIR}/build.log"
rm -rf ${BUILD_OUTPUT_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}

# Raspberry Pi 4 (BCM2711)
DEFCONFIG=defconfig 
# Uses a generic ARM64 base configuration suitable for QEMU's 'virt' machine type on Mac mini, 
# instead of the bcm2711_defconfig which is specific to actual Raspberry Pi 4 hardware.

KERNEL=kernel8
echo "Make config $(date +%y%m%d_%T)" &> ${BUILD_LOG}
(time make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O="${BUILD_OUTPUT_DIR}" ${DEFCONFIG}) &>> ${BUILD_LOG}

echo "Building kernel $(date +%y%m%d_%T)" &>> ${BUILD_LOG}
(time make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O="${BUILD_OUTPUT_DIR}" Image modules dtbs) &>> ${BUILD_LOG}

echo "Finish Build $(date +%y%m%d_%T)" &>> ${BUILD_LOG}

