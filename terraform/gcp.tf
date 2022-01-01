provider "google" {
  credentials = file("terraform-sa-key.json")
  project = var.project_id
  region = "us-central1"
  zone = "us-central1-a"
}

# IP Address of the instance
resource "google_compute_address" "ip_address" {
  name         = "learningspacepro-ip-${terraform.workspace}"
}

# Network
resource "google_compute_network" "my-network" {
  name = "default"
}

# Firewall Rules
resource "google_compute_firewall" "allow-http" {
  name = "allow-http-${terraform.workspace}"
  network = "${google_compute_network.my-network.self_link}"
  
  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-http-${terraform.workspace}"]    

}

# OS Image
resource "google_compute_image" "cos-image" {
  family = "cos-81-lts"
  project = "cos-cloud"
}

# Compute Engine Instance
resource "google_compute_instance" "instance" {
  name = "learningspacepro-${terraform.workspace}"
  machine_type = var.gcp_machine_type
  zone = "us-central1-a"
  
  tags = google_compute_firewall.allow-http.target_tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.cos_image.self_link
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  service_account {
    scopes = ["storage-ro"]
  }
}