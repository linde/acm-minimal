resource "google_gke_hub_feature" "acm" {
  name     = "configmanagement"
  location = "global"

  provider = google-beta
  depends_on = [
    google_project_service.hub,
    google_project_service.acm
  ]
}
