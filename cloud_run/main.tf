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
    task_count  = 30

    template {
      timeout = "3600s" # 1 hour
      containers {
        image = "us-central1-docker.pkg.dev/abproj1-dev-738828/gcf-artifacts/alpinechrome:new_3"
        resources {
          limits = {
            cpu    = "1"
            memory = "1Gi"
          }
        }
        args = [ "https://nightly-dot-shaka-player-demo.appspot.com/demo/#audiolang=en-US;textlang=en-US;cmcd.enabled=true;uilang=en-US;assetBase64=eyJuYW1lIjoic2t5IG5ld3MgIiwic2hvcnROYW1lIjoiIiwiaWNvblVyaSI6IiIsIm1hbmlmZXN0VXJpIjoiaHR0cHM6Ly9zYXRwb2MuY29tOjEyOTEwL2Rhc2gvU2VydmljZTIvbWFuaWZlc3QubXBkIiwic291cmNlIjoiQ3VzdG9tIiwiZm9jdXMiOmZhbHNlLCJkaXNhYmxlZCI6ZmFsc2UsImV4dHJhVGV4dCI6W10sImV4dHJhVGh1bWJuYWlsIjpbXSwiZXh0cmFDaGFwdGVyIjpbXSwiY2VydGlmaWNhdGVVcmkiOm51bGwsImRlc2NyaXB0aW9uIjpudWxsLCJpc0ZlYXR1cmVkIjpmYWxzZSwiZHJtIjpbIk5vIERSTSBwcm90ZWN0aW9uIl0sImZlYXR1cmVzIjpbIlZPRCJdLCJsaWNlbnNlU2VydmVycyI6eyJfX3R5cGVfXyI6Im1hcCJ9LCJvZmZsaW5lTGljZW5zZVNlcnZlcnMiOnsiX190eXBlX18iOiJtYXAifSwibGljZW5zZVJlcXVlc3RIZWFkZXJzIjp7Il9fdHlwZV9fIjoibWFwIn0sInJlcXVlc3RGaWx0ZXIiOm51bGwsInJlc3BvbnNlRmlsdGVyIjpudWxsLCJjbGVhcktleXMiOnsiX190eXBlX18iOiJtYXAifSwiZXh0cmFDb25maWciOm51bGwsImV4dHJhVWlDb25maWciOm51bGwsImFkVGFnVXJpIjpudWxsLCJpbWFWaWRlb0lkIjpudWxsLCJpbWFBc3NldEtleSI6bnVsbCwiaW1hQ29udGVudFNyY0lkIjpudWxsLCJpbWFNYW5pZmVzdFR5cGUiOm51bGwsIm1lZGlhVGFpbG9yVXJsIjpudWxsLCJtZWRpYVRhaWxvckFkc1BhcmFtcyI6bnVsbCwidXNlSU1BIjp0cnVlLCJtaW1lVHlwZSI6bnVsbH0=;panel=CUSTOM%20CONTENT;build=uncompiled" ]
      }
    }
  }
}

