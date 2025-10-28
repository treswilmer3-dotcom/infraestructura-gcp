
# Configuración de la red VPC
resource "google_compute_network" "vpc" {
  name                    = "devops-spring-network"
  project                 = "proyectospring-476500"
  auto_create_subnetworks = false
  mtu                     = 1460
}

# Configuración de la subred
resource "google_compute_subnetwork" "subnet" {
  name          = "devops-spring-subnet"
  project       = "proyectospring-476500"
  ip_cidr_range = "192.168.10.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

# Reglas de firewall
resource "google_compute_firewall" "allow_http" {
  name    = "devops-spring-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "devops-spring-allow-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow_app" {
  name    = "devops-spring-allow-app"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app-server"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "devops-spring-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22025"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# IP pública estática
resource "google_compute_address" "static_ip" {
  name    = "devops-spring-ip"
  project = "proyectospring-476500"
}

# Instancia de Compute Engine
resource "google_compute_instance" "app" {
  name         = "devops-spring-instance"
  project      = "proyectospring-476500"
  machine_type = "e2-micro"  # Nivel gratuito elegible
  zone         = "us-central1-a"
  tags         = ["http-server", "https-server", "app-server", "ssh"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8"
      size  = 30  # GB - tamaño mínimo recomendado
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = file("${path.module}/scripts/user-data.sh")

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key_path}")}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}