variable "project_id" {
  description = "El ID del proyecto de GCP"
  type        = string
  default     = "ProyectoSpring"
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
  default     = "devops-user"
}

variable "ssh_public_key_path" {
  description = "Ruta completa a la clave pública SSH"
  type        = string
  default     = "C:\\Users\\Terminal\\.ssh\\id_rsa.pub"
}