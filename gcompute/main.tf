provider "google" {
    project     = "abproj1-dev-738828"
    region      = "us-central1"
    credentials = file("PATH/TO/CREDENTIALS/FILE")
}

resource "google_compute_instance" "default" {
  count        = 10
  name         = "vm-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  tags         = ["iap"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2404-noble-amd64-v20250409"
    }
  }

  network_interface {
    network = "abproj1-dev-disc-vpc"
    subnetwork = "ab-central1"
    access_config {}
  }

  metadata = {
    user-data = file("../ec2/install.sh")
  }
}
