variable "project" {
  type = string
}

variable "sync_repo" {
  type = string
}

variable "sync_branch" {
  type = string
}

variable "policy_dir" {
  type = string
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
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "google_container_cluster" "cluster" {
  provider           = google-beta
  name               = "sfl-acm-${random_id.rand.hex}"
  location           = "us-central1-a"
  initial_node_count = 4
}

resource "google_gke_hub_membership" "membership" {
  provider      = google-beta
  membership_id = "membership-${random_id.rand.hex}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.cluster.id}"
    }
  }
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
        sync_repo = var.sync_repo
        sync_branch = var.sync_branch
        policy_dir = var.policy_dir
        secret_type = "none"
      }
    }
  }
}
