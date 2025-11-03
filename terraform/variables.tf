variable "project_id" {
  description = "proyectopruebasvale" #ID del proyecto GCP
  type        = string
  default     = "DevOpsLab"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "vpc_name" {
  type    = string
  default = "devops-spring-network"
}

variable "subnet_name" {
  type    = string
  default = "devops-spring-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "192.168.10.0/24"
}

variable "ssh_user" {
  type    = string
  default = "devops"
}

variable "ssh_public_key" {
  description = "Clave pública SSH (formato: ssh-rsa ...)"
  type        = string
  default     = ""
}

variable "ssh_port" {
  type    = number
  default = 22025
}

variable "allowed_ssh_cidr" {
  description = "IP pública permitida para SSH."
  type        = string
  default     = "190.130.148.144/32"
}

variable "instance_name" {
  type    = string
  default = "devops-spring-instance"
}

variable "instance_machine_type" {
  type    = string
  default = "e2-micro"
}

variable "boot_disk_size_gb" {
  type    = number
  default = 30
}
