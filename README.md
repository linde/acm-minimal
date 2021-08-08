# Repo info

The contents of this repo will be used for examples to accompany a short series of  blog articles explaining how to enable [Anthos Config Management (ACM)](https://cloud.google.com/anthos/config-management) with Terraform. 

The first part explains how to use teraform to create a cluster and manage its config from git via [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview). 

Part two will build on that to add guard rails for the cluster via [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller). 

Subsequent articles will discuss other aspects of ACM to manage your GCP infrastrcuture.

The structure of the repo will be as follows:

```bash
ROOT
│   README.md
└───part1
    |   README.md 
│   └───terraform
│       │   main.tf
│       │   variables.tf
│       config-root
│       │   wordpress-bundle.yaml
└───part2
|   README.md
│   └───terraform
│       │   main.tf
│       │   variables.tf
│       config-root
│       │   policy-controller-constaints.yaml
│       │   wordpress-bundle.yaml
```
