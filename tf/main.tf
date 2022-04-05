
terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "google_container_cluster" "cluster" {
  provider           = google-beta
  name               = "sfl-acm-${random_id.rand.hex}"
  location           = var.zone
  initial_node_count = 10
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

resource "google_gke_hub_feature" "acm" {
  provider = google-beta
  name     = "configmanagement"
  location = "global"
}

resource "google_gke_hub_feature_membership" "feature_member" {
  provider   = google-beta
  location   = "global"
  feature    = google_gke_hub_feature.acm.name
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo      = "https://github.com/linde/acm-minimal.git"
        sync_branch    = "httpbin-poco"
        policy_dir     = "config-root"
        secret_type    = "none"
        sync_wait_secs = "60"
      }
    }
    policy_controller {
      enabled                    = true
      referential_rules_enabled  = true
      template_library_installed = true
    }

  }
}


