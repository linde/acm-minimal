


# Simple barebones GKE with ACM (configsync, policy controller)

The following is a minimal terraform example to stand up a cluster and install 
configsync using config from [../config-root] and enforce policies via Policy
Controller.


## create a project, values below are in experimental-anthos and joonix billing account

```bash
export PROJECT=[your project]
export FOLDER=[your folder]
export BILLING_ACCOUNT=[your billing account]
```

# login to GCP, installing gcloud as necessary
```bash
sudo apt install google-cloud-sdk
sudo apt install google-cloud-sdk-gke-gcloud-auth-plugin 

gcloud auth application-default login
```

# create a new project under the folder and enable necessary APIs

we could do this all in terraform too, but this way the example below is minimal
and only focused on the hub, configmanagement and policy controller. Additionally
we enable APIs for ASM as well for subsequent explorations.


```bash
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
```

## now, go ahead and apply the config

```bash
terraform init
terraform plan --var project=$PROJECT
terraform apply -auto-approve -var project=$PROJECT
```

## check status of its sync via
```bash
gcloud beta container hub config-management status --project=$PROJECT
```


## check violation status by

```bash
kubectl get constraints
kubectl get constraints -o=jsonpath='{..violations}' | jq . 
```
