
# Minimal GKE with ACM that can send Metrics to Cloud Monitoring

The following is a minimal terraform example to stand up a cluster and install 
configsync using config from [config-root](./config-root) and enforce policies via Policy
Controller.

Additionally, it enables IAM for the GCE service account so it can post metrics to Cloud Monitoring.

## create a project, values below are in experimental-anthos and joonix billing account

```bash
export PROJECT=[your project]
export FOLDER=[your folder]
export BILLING_ACCOUNT=[your billing account]
```

# login to GCP, installing gcloud as necessary and creating a fresh project
```bash
sudo apt install google-cloud-sdk
sudo apt install google-cloud-sdk-gke-gcloud-auth-plugin 

gcloud auth application-default login

gcloud projects create $PROJECT --folder=$FOLDER
gcloud beta billing projects link $PROJECT --billing-account $BILLING_ACCOUNT
  
```

## now, go ahead and apply the config

```bash
terraform init
terraform plan --var project=$PROJECT
terraform apply -auto-approve -var project=$PROJECT
```


> if you get an error along the lines of `Error: Error creating Feature: Resource already exists` for `google_gke_hub_feature.acm`, then this resource is managed elsewhere. You can either comment out the block for this resource, or import it to start managing it. The latter can be accomplished via `terraform import  --var project=$PROJECT google_gke_hub_feature.acm projects/${PROJECT}/locations/global/features/configmanagement`.

## check status of its sync via
```bash
gcloud beta container hub config-management status --project=$PROJECT
```


## check violation status by

```bash
kubectl get constraints
kubectl get constraints -o=jsonpath='{..violations}' | jq . 
```

## you can now also see ConfigSync metrics

Navigate to the [Metrics Explorer](https://pantheon.corp.google.com/monitoring/metrics-explorer) and filter using the term `declared_resources`.

