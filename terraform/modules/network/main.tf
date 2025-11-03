variable "project_id" {}
variable "region" {}
variable "vpc_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.self_link
}

# Firewall: allow HTTP/HTTPS (opcional)
resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}