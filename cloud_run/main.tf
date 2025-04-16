provider "google" {
    project     = "abproj1-dev-738828"
    region      = "us-central1"
    credentials = file("PATH/TO/CREDENTIALS/FILE")
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
  disable_on_destroy = true
}

resource "google_cloud_run_v2_job" "default" {
  name     = "dashapp"
  location = "us-central1"

  deletion_protection = false # set to "true" in production

  template {
    task_count  = 500
    parallelism = 500

    template {
      containers {
        image = "us-central1-docker.pkg.dev/abproj1-dev-738828/gcf-artifacts/dashworld:latest"
      }
    }
  }
}

