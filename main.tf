terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.56.0"
    }
  }
}

provider "google" {
  credentials = file("freebsd-pot-bd8591be3539.json")
  project = "freebsd-pot"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
  mtu = 1500
}

resource "google_compute_firewall" "allow-ssh-ingress-from-iap" {
  name = "allow-ssh-ingress-from-iap"
  network = google_compute_network.vpc_network.name

  source_ranges=["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

resource "google_compute_instance" "freebsd-12" {
  name         = "freebsd-12-2"
  machine_type = "c2-standard-4"

  boot_disk {
    initialize_params {
      image = "projects/freebsd-org-cloud-dev/global/images/freebsd-12-2-release-amd64"
    }
  }
  scratch_disk {
    interface = "SCSI"
  }
  scheduling {
    preemptible = "true"
    automatic_restart = "false"
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
