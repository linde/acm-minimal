
/***

Simple barebones GKE with ACM (configsync, policy controller)

## create a project, values below are in experimental-anthos and joonix billing account

export PROJECT=[your project]
export FOLDER=[your folder]
export BILLING_ACCOUNT=[your billing account]


# as necessary
sudo apt install google-cloud-sdk
sudo apt install google-cloud-sdk-gke-gcloud-auth-plugin 


gcloud auth application-default login

# create a new project under the folder and enable necessary APIs
# we could do this all in terraform too, but this way the example below is minimal
# and only focused on the hub, configmanagement and policy controller.

gcloud projects create $PROJECT --folder=$FOLDER
gcloud beta billing projects link $PROJECT --billing-account $BILLING_ACCOUNT

gcloud services enable --project=$PROJECT \
  anthos.googleapis.com \
  anthosconfigmanagement.googleapis.com \
  cloudtrace.googleapis.com \
  cloudresourcemanager.googleapis.com \
  container.googleapis.com \
  compute.googleapis.com \
  gkeconnect.googleapis.com \
  gkehub.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  logging.googleapis.com \
  meshca.googleapis.com \
  meshtelemetry.googleapis.com \
  meshconfig.googleapis.com \
  monitoring.googleapis.com \
  stackdriver.googleapis.com \
  sts.googleapis.com

terraform init
terraform plan --var project=$PROJECT
terraform apply -auto-approve -var project=$PROJECT

# check status of its sync via
gcloud beta container hub config-management status --project=$PROJECT

# check violation status by

kubectl get constraints
kubectl get constraints -o=jsonpath='{..violations}' | jq . 

***/



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
        sync_branch    = "acm-pccl-cis-asm"
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


