output "instance_public_ip" {
  description = "IP pública de la instancia"
  value       = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
}

output "instance_name" {
  description = "Nombre de la instancia"
  value       = google_compute_instance.app.name
}

output "vpc_name" {
  description = "Nombre de la VPC creada"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Nombre de la subred creada"
  value       = google_compute_subnetwork.subnet.name
}

output "application_url" {
  description = "URL para acceder a la aplicación"
  value       = "http://${google_compute_instance.app.network_interface[0].access_config[0].nat_ip}:8080"
}

output "ssh_command" {
  description = "Comando para conectarse por SSH a la instancia"
  value       = "ssh -p 22025 ${var.ssh_user}@${google_compute_instance.app.network_interface[0].access_config[0].nat_ip}"
}