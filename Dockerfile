FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
	apt install -y sudo wget tar neovim git gzip python3 curl gdb \
	bc bison flex libssl-dev make libc6-dev libncurses5-dev libelf-dev crossbuild-essential-arm64 gcc-arm-linux-gnueabihf

RUN groupadd kernel_dev && \
	useradd -m -g kernel_dev -s /bin/bash kernel_dev && \
	echo 'kernel_dev:kernel_dev' | chpasswd && \
	adduser kernel_dev sudo

USER kernel_dev
WORKDIR /home/kernel_dev
COPY in_container/* /home/kernel_dev/

EXPOSE 8000
CMD ["python3", "-m", "http.server", "8000"]

