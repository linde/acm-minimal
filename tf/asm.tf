
module "asm" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/asm"

  cluster_endpoint = google_container_cluster.cluster.endpoint
  cluster_name     = google_container_cluster.cluster.name
  location         = var.zone
  project_id       = var.project
  enable_all       = true

}


