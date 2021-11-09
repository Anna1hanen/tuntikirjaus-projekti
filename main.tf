#build infrastructure
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file) 

  project = var.project
  region  = var.region
  zone    = var.zone
}

# VPC-networkin rakennus
resource "google_compute_network" "vpc_network" {
  name = "tuntikirjaus-vpc"
  auto_create_subnetworks = false
}