#!/bin/bash

# Variables
DOCKER_HUB_USERNAME="joaquinabal"
IMAGE_NAME="web1-abal-tp2"
LOCAL_IMAGE="${IMAGE_NAME}:latest"
REMOTE_IMAGE="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:latest"

#Construyo la imagen Docker
echo "Construyendo la imagen Docker..."
docker build -t "$LOCAL_IMAGE" -f /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/Dockerfile /home/vagrant/UTN-FRA_SO_Examenes/202406/docker

#Etiqueto la imagen para Docker Hub
echo "Etiquetando la imagen para Docker Hub..."
docker tag "$LOCAL_IMAGE" "$REMOTE_IMAGE"

#Logueo en Docker Hub
echo "Logueándose en Docker Hub..."
docker login -u "$DOCKER_HUB_USERNAME"

#Pusheo la oimagen a Docker Hub
echo "Pusheando la imagen a Docker Hub..."
docker push "$REMOTE_IMAGE"


echo "Imagen pusheada exitosamente como $REMOTE_IMAGE"

