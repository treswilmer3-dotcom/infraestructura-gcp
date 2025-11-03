
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Configuración del proveedor de Google
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Módulo de red
module "network" {
  source = "./modules/network"
  
  project_id    = var.project_id
  region        = var.region
  vpc_name     = var.vpc_name
  subnet_cidr  = var.subnet_cidr
}

# Módulo de reglas de firewall
module "firewall" {
  source = "./modules/firewall"
  
  project_id = var.project_id
  vpc_name  = module.network.vpc_name
  
  # Lista de rangos IP permitidos (puedes restringir esto según sea necesario)
  allowed_ips = var.allowed_ips
}

# Módulo de instancia de Compute
module "compute" {
  source = "./modules/compute"
  
  project_id     = var.project_id
  region         = var.region
  zone           = var.zone
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  vpc_name       = module.network.vpc_name
  subnet_name    = module.network.subnet_name
  ssh_user       = var.ssh_user
  ssh_public_key = file(var.ssh_public_key_path)
  
  # Tags para las reglas de firewall
  instance_tags = ["http-server", "https-server", "app-server", "ssh"]
  
  # Script de inicio
  startup_script = file("${path.module}/scripts/user-data.sh")
}

# Outputs útiles
output "instance_public_ip" {
  value       = module.compute.instance_public_ip
  description = "IP pública de la instancia"
}

output "instance_name" {
  value       = module.compute.instance_name
  description = "Nombre de la instancia"
}