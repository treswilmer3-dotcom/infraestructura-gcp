# Creación de la red VPC
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "REGIONAL"
  
  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

# Creación de la subred
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  
  private_ip_google_access = true
}

# Regla de firewall para permitir tráfico interno
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "icmp"
  }
  
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  source_ranges = [var.subnet_cidr]
}

# Habilitar APIs necesarias
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}

# Outputs
data "google_compute_network" "vpc" {
  name = google_compute_network.vpc.name
  depends_on = [google_compute_network.vpc]
}

output "network_name" {
  value = google_compute_network.vpc.name
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}
