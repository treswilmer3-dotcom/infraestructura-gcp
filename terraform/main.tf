# Configuración principal de la infraestructura

# Módulo de red
module "network" {
  source = "./modules/network"
  
  project_id   = var.project_id
  region       = var.region
  network_name = var.network_name
  subnet_cidr  = var.subnet_cidr
}

# Módulo de instancia de VM
module "vm" {
  source = "./modules/vm"
  
  project_id     = var.project_id
  region         = var.region
  zone           = var.zone
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  network        = module.network.network_self_link
  subnetwork     = module.network.subnet_self_link
  ssh_user       = var.ssh_user
  ssh_public_key = file(var.ssh_public_key_path)
  
  # Tags para reglas de firewall
  tags = ["http-server", "https-server", "ssh"]
  
  # Script de inicio
  startup_script = templatefile("${path.module}/modules/vm/startup.tpl", {
    docker_image = var.docker_image
  })
}

# Outputs
output "instance_public_ip" {
  value       = module.vm.instance_public_ip
  description = "IP pública de la instancia"
}

output "instance_name" {
  value       = module.vm.instance_name
  description = "Nombre de la instancia"
}
