# Outputs para la red
output "network_name" {
  value       = module.network.network_name
  description = "Nombre de la red VPC creada"
}

output "subnet_name" {
  value       = module.network.subnet_name
  description = "Nombre de la subred creada"
}

# Outputs para la instancia
output "instance_id" {
  value       = module.vm.instance_id
  description = "ID de la instancia de Compute Engine"
}

output "instance_public_ip" {
  value       = module.vm.instance_public_ip
  description = "IP pública de la instancia"
}

output "instance_private_ip" {
  value       = module.vm.instance_private_ip
  description = "IP privada de la instancia"
}

# URL de la aplicación (si aplica)
output "app_url" {
  value       = "http://${module.vm.instance_public_ip}"
  description = "URL de la aplicación"
}
