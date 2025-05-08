provider "google" {
    project     = "abproj1-dev-738828"
    region      = "us-central1"
    credentials = file(var.gcloudcreds)
}

resource "google_compute_instance" "client" {
  count        = 15
  name         = "cli-${count.index}"
  machine_type = "n1-standard-1"
  #zone         = "us-central1-b"
  tags         = ["iap"]

  zone         = count.index % 3 == 1 ? "us-central1-a" : count.index % 3 == 2 ? "us-central1-b" : "us-central1-c"

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
