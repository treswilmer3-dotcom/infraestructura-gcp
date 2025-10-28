terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = "proyectospring-476500"
  region  = "us-central1"
  zone    = "us-central1-a"
}
