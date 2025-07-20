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

### Port Usage
 This setup uses port 8000 on the host machine for accessing kernel build artifacts from within the Docker container via a simple web server.
Please ensure this port is available or adjust your Docker port mapping if necessary.

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
## Download file for run virtual linux on host
```zsh
# zsh - host
# Download file for run virtual linux
cd kernel_file
./get_file.sh
```
- 2025-05-13-raspios-bookworm-arm64-lite.qcow2: Virtual Disk Image
- Image: Builded Kernel Image from container
### How it works?
- Port Exposure: The Dockerfile includes EXPOSE 8000, signaling that the container will listen on port 8000.
- Web Server: The CMD ["python3", "-m", "http.server", "8000"] command automatically starts a lightweight Python HTTP server on port 8000 when the container runs. This server serves files from the container's current working directory (where the kernel is built).
- if you want to download file in container, you can use simple web server without using 'docker cp'.(localhost:8000)
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
## how to passwd DEFAULT USER
## why? /dev/vda2 -> -append "console=ttyAMA0 root=/dev/vda2 rw init=/bin/bash"
### init=/bin/bash -> direct shell booting for passwd
# mount -o remount,rw /dev/vda2 /
## [  151.840967] EXT4-fs (vda2): re-mounted d4cc7d63-da78-48ad-9bdd-64ffbba449a8.
# root@(none):/# passwd pi
## New password:
## Retype new password:
## passwd: password updated successfully
# root@(none):/# sync
## kill qemu process (Ctrl+C in the QEMU terminal)
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
screen /dev/ttys??? # ex) check in QEMU output: char device redirected to /dev/ttys005 (label serial0)
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
