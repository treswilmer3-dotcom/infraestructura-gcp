#!/bin/bash
set -e

# 1) Instalar Docker y Docker Compose
echo "Instalando Docker..."
dnf -y update
dnf -y install -y yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install -y docker-ce docker-ce-cli containerd.io

# Iniciar y habilitar Docker
systemctl enable --now docker

# Instalar Docker Compose
DOCKER_COMPOSE_VERSION="v2.22.0"
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# 2) Configurar Firewall básico
echo "Configurando firewall..."
systemctl enable --now firewalld
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --reload

# 3) Mejoras de seguridad SSH
echo "Configurando SSH..."
SSH_PORT=22025
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#Port .*/Port 22025/g' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# Reiniciar SSH para aplicar cambios
systemctl restart sshd

echo "Configuración de infraestructura completada exitosamente!"
echo "Recuerda configurar tu cliente SSH para usar el puerto 22025"
