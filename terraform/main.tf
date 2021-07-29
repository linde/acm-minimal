locals {
  project = "stevenlinde-demo-01"
}

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.73.0"
    }
  }
}
provider "google-beta" {
  project = local.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "google_project_service" "container" {
  project            = local.project
  service            = "container.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "hub" {
  project = local.project
  service = "gkehub.googleapis.com"
}
resource "google_project_service" "acm" {
  project = local.project
  service = "anthosconfigmanagement.googleapis.com"
}
resource "google_container_cluster" "cluster" {
  provider           = google-beta
  name               = "sfl-acm-${random_id.rand.hex}"
  location           = "us-central1-a"
  initial_node_count = 4
  depends_on = [
    google_project_service.container
  ]
}

resource "google_gke_hub_membership" "membership" {
  provider      = google-beta
  membership_id = "membership-${random_id.rand.hex}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.cluster.id}"
    }
  }
  depends_on = [
    google_project_service.hub
  ]
}

resource "google_gke_hub_feature" "acm" {
  name     = "configmanagement"
  location = "global"

  provider = google-beta
  depends_on = [
    google_project_service.hub,
    google_project_service.acm
  ]
}

resource "google_gke_hub_feature_membership" "feature_member" {
  provider   = google-beta
  location   = "global"
  feature    = google_gke_hub_feature.acm.name
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.8.0"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo   = "git@github.com:linde/acm-minimal.git"
        sync_branch = "minimal-tf-hub-wordpress"
        policy_dir  = "config-root"
        secret_type = "none"
      }
    }
    policy_controller {
      enabled                    = true
      referential_rules_enabled  = true
      template_library_installed = true
    }

  }
}
