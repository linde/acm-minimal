
# Minimal GKE with ACM that can send Metrics to Cloud Monitoring

The following is a minimal terraform example to stand up a cluster and install 
configsync using config from [../config-root] and enforce policies via Policy
Controller.

Additionally, it has the default GKE service account (actually the GCE service account) configured so it can post metrics to Cloud Monitoring.

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
