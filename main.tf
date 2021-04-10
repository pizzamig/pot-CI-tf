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

resource "google_compute_firewall" "allow-ssh-ingress-from-iap" {
  name = "allow-ssh-ingress-from-iap"
  network = "default"

  source_ranges=["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

resource "google_compute_instance" "freebsd-13" {
  name         = "freebsd-13-0"
  machine_type = "c2-standard-8"

  boot_disk {
    initialize_params {
      image = "projects/freebsd-org-cloud-dev/global/images/family/freebsd-13-0-snap"
    }
  }
  scratch_disk {
    interface = "NVME"
  }
  scheduling {
    preemptible = "true"
    automatic_restart = "false"
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}
