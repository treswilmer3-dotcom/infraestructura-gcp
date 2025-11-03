#!/bin/bash

# Actualizar el sistema
apt-get update -y
apt-get upgrade -y

# Instalar dependencias
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Agregar clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configurar el repositorio estable de Docker
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Iniciar y habilitar Docker
systemctl start docker
systemctl enable docker

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Crear usuario para Docker (opcional)
# useradd -m -s /bin/bash dockeruser
# usermod -aG docker dockeruser

# Desplegar la aplicación
cat > /home/ubuntu/docker-compose.yml << EOF
version: '3'
services:
  app:
    image: ${docker_image}
    container_name: app
    restart: always
    ports:
      - "80:80"
      - "443:443"
    environment:
      - NODE_ENV=production
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
EOF

# Iniciar la aplicación
cd /home/ubuntu
docker-compose up -d
