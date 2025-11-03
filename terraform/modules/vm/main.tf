variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "instance_name" {}
variable "machine_type" {}
variable "boot_disk_size_gb" {}
variable "network" {}
variable "subnetwork" {}
variable "ssh_user" {}
variable "ssh_public_key" {}
variable "ssh_port" {}
variable "allowed_ssh_cidr" {}

data "google_compute_image" "rocky" {
  family  = "rocky-9"
  project = "rocky-linux-cloud"
}

resource "google_compute_address" "static_ip" {
  name   = "devops-spring-ip"
  region = var.region
}

resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.rocky.self_link
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    ssh-keys       = "${var.ssh_user}:${var.ssh_public_key}"
    startup-script = templatefile("${path.module}/startup.tpl", {
                        ssh_user = var.ssh_user,
                        ssh_port = var.ssh_port
                      })
  }

  tags = ["devops-spring"]
}

resource "google_compute_firewall" "allow_ssh_custom" {
  name    = "${var.instance_name}-allow-ssh-custom"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [tostring(var.ssh_port)]
  }

  source_ranges = [var.allowed_ssh_cidr]
  target_tags   = ["devops-spring"]
}

output "instance_name" {
  value = google_compute_instance.vm.name
}

output "instance_ip" {
  value = google_compute_address.static_ip.address
}