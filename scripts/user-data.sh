#!/bin/bash

# Actualizar el sistema
sudo dnf update -y

# Instalar paquetes necesarios
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2 git

# Agregar el repositorio de Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Instalar Docker
sudo dnf install -y docker-ce docker-ce-cli containerd.io

# Iniciar y habilitar el servicio de Docker
sudo systemctl start docker
sudo systemctl enable docker

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Crear directorio para la aplicación
mkdir -p /opt/app
cd /opt/app

# Crear archivo docker-compose.yml
cat > docker-compose.yml << 'EOL'
version: '3.8'
services:
  app:
    image: wilinvest/spring-boot-app:v1.0.0
    container_name: spring-boot-app
    restart: always
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOL

# Iniciar la aplicación con Docker Compose
docker-compose up -d

# Configurar firewall local
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=22025/tcp
sudo firewall-cmd --reload

# Instalar y habilitar fail2ban para seguridad
sudo dnf install -y epel-release
sudo dnf install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Configuración básica de seguridad
sudo sed -i 's/#Port 22/Port 22025/' /etc/ssh/sshd_config
sudo systemctl restart sshd
