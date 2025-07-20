# Overview
This repository provides a setup for kernel debugging on a Mac mini(2024, arm64) using QEMU, Docker, Raspberry PI4 OS Image 

# Environment
## HOST
- Mac mini(2024)
- arm64 
    ``` zsh
    uname -m
    ```
## Virtualization
- Docker version 28.0.4, build b8034c0
- QEMU emulator version 10.0.2

# Run Step
## Install Qemu, Docker
## Run Docker Container for build kernel
```zsh
cd dev-kernel
./run_dev_cont.sh
```
## Build kernel in Container
1. Attach to container
```zsh
# zsh - host
docker exec -it arm64_kernel_dev bash
```
2. build kernel
```bash
# bash - container
./build.sh
```
3. check build output
```bash
# bash - container
cat ./linux/build/build.log
ls -al ./linux/build/vmlinux ./linux/build/arch/arm64/boot/Image
```
- vmlinux: for GDB debugging symbol
- Image: for boot
## Run QEMU using builded kernel
### default
```zsh
# zsh - host
./run_qemu.sh
```
### for 'passwd pi'
```zsh
# zsh - host
./run_qemu_for_passwd.sh
```
### for gdb
```zsh
# zsh - host
./run_qemu_for_gdb.sh
## Starting QEMU with image: ./kernel_file/
## 2025-05-13-raspios-bookworm-arm64-lite.qcow2
## QEMU 10.0.2 monitor - type 'help' for more information
## char device redirected to /dev/ttys005 (label serial0)
### (optional) connect to virtual linux
## another terminal
screen /dev/ttys005 
```
## Run GDB in Container
- another terminal
```bash
# bash - container

./run_gdb.sh
```

# Reference
- https://docs.docker.com/desktop/setup/install/mac-install/
- https://www.qemu.org/download/#macos
- https://www.raspberrypi.com/software/operating-systems/
- https://www.raspberrypi.com/documentation/computers/linux_kernel.html
- https://github.com/raspberrypi/linux/tree/stable_20250702
