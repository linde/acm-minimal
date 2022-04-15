resource "google_project_service" "container" {
  project            = var.project
  service            = "container.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "hub" {
  project            = var.project
  service            = "gkehub.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "acm" {
  project            = var.project
  service            = "anthosconfigmanagement.googleapis.com"
  disable_on_destroy = false
}
