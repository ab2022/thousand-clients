provider "google" {
    project     = "abproj1-dev-738828"
    region      = "us-central1"
    credentials = file(var.gcloudcreds)
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_v2_job" "default" {
  name     = "dashapp"
  location = "us-central1"

  deletion_protection = false # set to "true" in production

  template {
    task_count  = 1000
    parallelism = 1000

    template {
      timeout = "2400s"
      containers {
        image = "us-central1-docker.pkg.dev/abproj1-dev-738828/gcf-artifacts/dashworld:1.15m"
        resources {
          limits = {
            cpu    = "1"
            memory = "1024Mi"
          }
        }
      }
    }
  }
}

