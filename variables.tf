variable "project_id" {
  description = "El ID del proyecto de GCP"
  type        = string
  default     = "proyectospring-476500"
}

variable "region" {
  description = "La región de GCP donde se desplegarán los recursos"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "La zona de GCP donde se desplegarán los recursos"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "devops-spring-network"
}

variable "subnet_cidr" {
  description = "Rango CIDR para la subred"
  type        = string
  default     = "192.168.10.0/24"
}

variable "instance_name" {
  description = "Nombre de la instancia de Compute Engine"
  type        = string
  default     = "devops-spring-instance"
}

variable "machine_type" {
  description = "Tipo de máquina para la instancia"
  type        = string
  default     = "e2-micro"
}

variable "docker_image" {
  description = "Imagen de Docker a desplegar"
  type        = string
  default     = "wilinvest/spring-boot-app:v1.0.0"
}

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

variable "allowed_ips" {
  description = "Lista de rangos IP permitidos para SSH y otros accesos"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # En producción, restringir esto a IPs específicas
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "service_account_email" {
  description = "Correo electrónico de la cuenta de servicio de GCP"
  type        = string
  default     = null
}

variable "enable_os_login" {
  description = "Habilitar OS Login para la instancia"
  type        = bool
  default     = true
}

variable "enable_serial_port" {
  description = "Habilitar puerto serie para la instancia"
  type        = bool
  default     = false
}