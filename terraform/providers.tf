terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  
  # Usar credenciales desde la variable de entorno
  credentials = file(exists("gcp_creds.json") ? "gcp_creds.json" : "/dev/null")
  
  # Configuración adicional para evitar errores de tiempo de espera
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform.read-only"
  ]
}
