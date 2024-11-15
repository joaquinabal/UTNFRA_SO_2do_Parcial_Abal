#!/bin/bash

# Variables
DOCKER_HUB_USERNAME="joaquinabal"
IMAGE_NAME="web1-abal-tp2"
REMOTE_IMAGE="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"

# Ejecuto el contenedor en el puerto 8080 del host
docker run -d -p 8080:80 "$REMOTE_IMAGE"

