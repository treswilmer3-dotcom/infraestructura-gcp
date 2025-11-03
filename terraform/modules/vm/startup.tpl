#!/bin/bash
set -e

SSH_USER="${ssh_user}"
SSH_PORT=${ssh_port}

# 1) Crear usuario
if ! id -u ${SSH_USER} >/dev/null 2>&1; then
  useradd -m -s /bin/bash ${SSH_USER}
  echo "${SSH_USER} ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${SSH_USER}
fi

mkdir -p /home/${SSH_USER}/.ssh
chmod 700 /home/${SSH_USER}/.ssh
chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh

# 2) Instalar Docker y Docker Compose
dnf -y update
dnf -y install -y yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install -y docker-ce docker-ce-cli containerd.io

systemctl enable --now docker

mkdir -p /usr/local/lib/docker/cli-plugins
DOCKER_COMPOSE_VERSION="v2.22.0"
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

usermod -aG docker ${SSH_USER}

# 3) Cambiar puerto SSH
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
if grep -q "^#Port" /etc/ssh/sshd_config || ! grep -q "^Port ${SSH_PORT}" /etc/ssh/sshd_config; then
  sed -i "s/^#Port .*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config || true
  if ! grep -q "^Port ${SSH_PORT}" /etc/ssh/sshd_config; then
    echo "Port ${SSH_PORT}" >> /etc/ssh/sshd_config
  fi
fi

systemctl restart sshd || true

echo "Instalación base completada."
