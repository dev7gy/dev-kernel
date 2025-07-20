#!/usr/bin/env zsh

VOLUME_NAME="kernel_dev"
IMG_NAME="ubuntu2204_arm64_dev"
CONTAINER_NAME="arm64_kernel_dev"

# Make volume
docker volume ls |grep ${VOLUME_NAME}
if [ $? -eq 0 ]; then
   echo "Volume[${VOLUME_NAME}] already exists, skipping"
else
   docker volume create ${VOLUME_NAME}
fi

# Make image
docker images |grep -q ${IMG_NAME}
if [ $? -eq 0 ]; then
    echo "Image[${IMG_NAME}] already exists, skipping build."
else
    echo "Building docker image ${IMG_NAME}..."
    docker build -t ${IMG_NAME} -f Dockerfile .   
fi

# Run Container
# 8000 is port for web server (Download files from container)
docker run --rm --name ${CONTAINER_NAME} -d -p 8000:8000 \
    -v ${VOLUME_NAME}:/home/${VOLUME_NAME} \
    ${IMG_NAME}

echo "Container[${CONTAINER_NAME}] is running. You can access it via port 8000."
