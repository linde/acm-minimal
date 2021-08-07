
variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
  default = "https://github.com/linde/acm-minimal.git"
}

variable "sync_branch" {
  type        = string
  description = "the git branch in the repo to sync"
  default = "minimal-tf-hub-wordpress"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default = "config-root"
}
  