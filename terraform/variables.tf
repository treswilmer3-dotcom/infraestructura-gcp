# Variables generales
variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
  default     = "proyectospring-476500"
}

variable "region" {
  description = "Región de GCP donde se desplegarán los recursos"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona de GCP donde se desplegará la instancia"
  type        = string
  default     = "us-central1-a"
}

# Variables de red
variable "network_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "devops-network"
}

variable "subnet_cidr" {
  description = "Rango CIDR para la subred"
  type        = string
  default     = "10.0.1.0/24"
}

# Variables de la instancia
variable "instance_name" {
  description = "Nombre de la instancia de Compute Engine"
  type        = string
  default     = "devops-instance"
}

variable "machine_type" {
  description = "Tipo de máquina para la instancia"
  type        = string
  default     = "e2-micro"
}

variable "docker_image" {
  description = "Imagen de Docker a desplegar"
  type        = string
  default     = "nginx:latest"
}

# Variables de autenticación
variable "ssh_user" {
  description = "Usuario SSH para acceder a la instancia"
  type        = string
  default     = "terraform"
}

variable "ssh_public_key_path" {
  description = "Ruta al archivo de clave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Variables de entorno
variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "enable_os_login" {
  description = "Habilitar OS Login para la instancia"
  type        = bool
  default     = true
}
