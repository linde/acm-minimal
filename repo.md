# Repo info

The contents of this repo will be used as an example to accompany Part 1 of the blog explaining how to enable ACM with Terraform.

The structure of the repo will be as follows:

```bash
ROOT
│   README.md
└───part1 # <= this repo will go here
│   └───terraform
│       │   acm_feature_enablement.tf
│       │   main.tf
│       config-root # unstructured repo
│       │   wordpress-bundle.yaml
└───part2
│   └───terraform
│       │   acm_feature_enablement.tf
│       │   main.tf
│       config-root # unstructured repo
│       │   wordpress-bundle.yaml
└───part3
│   └───terraform
│       │   acm_feature_enablement.tf
│       │   main.tf
│       config-root # in part3 we'll switch to structured repo format
│       └───cluster
│       └───namespaces
│       │   └───service.a
│       │       │   wordpress-bundle.yaml
│       │       │   namespace.yaml
│       └───system
│           │   repo.yaml
```
