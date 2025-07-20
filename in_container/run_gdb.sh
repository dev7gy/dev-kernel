#!/usr/bin/env bash
set -e

KERNEL_DEBUG_IMAGE="./linux/build/vmlinux"
if [[ ! -f "${KERNEL_DEBUG_IMAGE}" ]]; then
    echo "${KERNEL_DEBUG_IMAGE} not found. Please build kernel first."
    exit 1
fi

echo "check ${KERNEL_DEBUG_IMAGE} file (well-known symbol)"
nm -n ${KERNEL_DEBUG_IMAGE} |grep -e "start_kernel" -e "__sched_fork"

# Set target remote for Mac mini
MAC_OS_HOST_QEMU_GDB_SERVER="host.docker.internal:1234"
gdb "${KERNEL_DEBUG_IMAGE}" -ex "target remote ${MAC_OS_HOST_QEMU_GDB_SERVER}"

