

data "google_compute_default_service_account" "gce_default_sa" {
    project = var.project
}

resource "google_project_iam_binding" "gce_default_sa_metrics" {
  project = var.project
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${data.google_compute_default_service_account.gce_default_sa.email}",
  ]
}


