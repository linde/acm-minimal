resource "google_gke_hub_feature" "acm" {
  name     = "configmanagement"
  location = "global"

  provider = google-beta
}
