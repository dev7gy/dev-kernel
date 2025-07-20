#!/usr/bin/env zsh
set -e

IMG="2025-05-13-raspios-bookworm-arm64-lite"
if [[ ! -f "${IMG}.qcow2" ]]; then
    echo "${IMG}.qcow2 not found. Downloading and Coverting(qcow2) now..."
    DOWNLOAD_BASE_URL="https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2025-05-13"

    curl -O "${DOWNLOAD_BASE_URL}/${IMG}.img.xz"
    unxz "${IMG}.img.xz"
    # xz -d "${IMG}.img.xz"
    qemu-img convert -f raw -O qcow2 "${IMG}.img" "${IMG}.qcow2"
fi

echo "Download Recent Build Kernel Image"
rm -f ./Image
curl -O http://localhost:8000/linux/build/arch/arm64/boot/Image

