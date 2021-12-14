
variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}
variable "region" {
  type        = string
  description = "the GCP region where the cluster will be created"
  default     = "us-central1"
}
variable "zone" {
  type        = string
  description = "the GCP zone where the cluster will be created"
  default     = "us-central1-c"
}

output "gcloud_kubecontext" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.cluster.id} --zone ${var.zone} --project ${var.project}"
}
