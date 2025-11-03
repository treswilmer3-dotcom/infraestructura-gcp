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

# Configuración de backend (opcional, descomentar y configurar según sea necesario)
/*
terraform {
  backend "gcs" {
    bucket = "tu-bucket-para-estado"
    prefix = "terraform/state"
  }
}
*/
