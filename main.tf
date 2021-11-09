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
  name                    = "tuntikirjaus-vpc"
  auto_create_subnetworks = false
}

#Subnetworkin lisääminen
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "tuntikirjaus-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}


# VM-instanssin luonti
resource "google_compute_instance" "vm_instance" {
  name         = "tuntikirjaus-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
   network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}