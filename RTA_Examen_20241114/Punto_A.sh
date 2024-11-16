#!/bin/bash

# Variables
DISK1="/dev/sde" # Disco de 2GB
DISK2="/dev/sdf" # Disco de 1GB
VG_DATOS="vg_datos"
VG_TEMP="vg_temp"
LV_DOCKER="lv_docker"
LV_WORKAREAS="lv_workareas"
LV_SWAP="lv_swap"

# Preparar los discos
echo "Preparando los discos..."
sudo fdisk "$DISK1" <<EOF
n
p
1


t
8e
w
EOF

sudo fdisk "$DISK2" <<EOF
n
p
1


t
8e
w
EOF

# Crear Physical Volumes
echo "Creando Physical Volumes..."
sudo pvcreate "${DISK1}1" "${DISK2}1"

# Crear Volume Groups
echo "Creando Volume Groups..."
sudo vgcreate "$VG_DATOS" "${DISK1}1"
sudo vgcreate "$VG_TEMP" "${DISK2}1"

# Crear Logical Volumes
echo "Creando Logical Volumes..."
sudo lvcreate -L 5M -n "$LV_DOCKER" "$VG_DATOS"
sudo lvcreate -L 1.5G -n "$LV_WORKAREAS" "$VG_DATOS"
sudo lvcreate -L 512M -n "$LV_SWAP" "$VG_TEMP"

# Formatear los Logical Volumes
echo "Formateando los Logical Volumes..."
sudo mkfs.ext4 "/dev/$VG_DATOS/$LV_DOCKER"
sudo mkfs.ext4 "/dev/$VG_DATOS/$LV_WORKAREAS"
sudo mkswap "/dev/$VG_TEMP/$LV_SWAP"

# Crear puntos de montaje
echo "Creando puntos de montaje..."
sudo mkdir -p /var/lib/docker /work

# Montar los Logical Volumes
echo "Montando los Logical Volumes..."
sudo mount "/dev/$VG_DATOS/$LV_DOCKER" /var/lib/docker
sudo mount "/dev/$VG_DATOS/$LV_WORKAREAS" /work
sudo swapon "/dev/$VG_TEMP/$LV_SWAP"

# Configurar /etc/fstab
echo "Configurando /etc/fstab..."
echo "/dev/$VG_DATOS/$LV_DOCKER   /var/lib/docker  ext4  defaults  0 0" | sudo tee -a /etc/fstab
echo "/dev/$VG_DATOS/$LV_WORKAREAS /work           ext4  defaults  0 0" | sudo tee -a /etc/fstab
echo "/dev/$VG_TEMP/$LV_SWAP       swap            swap  defaults  0 0" | sudo tee -a /etc/fstab

# Verificación
echo "Verificación final..."
df -h
swapon --show
sudo lvdisplay

echo "Configuración completada exitosamente."

