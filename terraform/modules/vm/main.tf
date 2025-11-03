# IP pública estática
resource "google_compute_address" "static_ip" {
  name = "${var.instance_name}-ip"
}

# Instancia de Compute Engine
resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 30  # GB
      type  = "pd-ssd"
    }
  }
  
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
  
  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
  
  metadata_startup_script = var.startup_script
  
  service_account {
    scopes = ["cloud-platform"]
  }
  
  # Habilitar IP forwarding si es necesario
  can_ip_forward = false
  
  # Habilitar eliminación de protección
  deletion_protection = false
  
  # Habilitar protección contra eliminación de discos
  boot_disk {
    auto_delete = true
    device_name = "${var.instance_name}-boot"
    
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 30
      type  = "pd-ssd"
    }
  }
  
  # Configuración de metadatos
  metadata = {
    enable-oslogin = var.enable_os_login
  }
  
  # Configuración de etiquetas
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Reglas de firewall para la instancia
resource "google_compute_firewall" "allow_http" {
  name    = "${var.instance_name}-allow-http"
  network = var.network
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  target_tags = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.instance_name}-allow-https"
  network = var.network
  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  
  target_tags = ["https-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.instance_name}-allow-ssh"
  network = var.network
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  target_tags = ["ssh"]
  source_ranges = ["0.0.0.0/0"]  # En producción, restringir a IPs específicas
}

# Outputs
output "instance_id" {
  value = google_compute_instance.vm.instance_id
}

output "instance_name" {
  value = google_compute_instance.vm.name
}

output "instance_public_ip" {
  value = google_compute_address.static_ip.address
}

output "instance_private_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}
