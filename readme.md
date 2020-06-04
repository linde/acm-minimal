

# Overview

this is a minimal [Config Connector](https://cloud.google.com/config-connector/) repo for [Config Sync](https://cloud.google.com/kubernetes-engine/docs/add-on/config-sync), ie
not [Anthos Config Management](https://cloud.google.com/anthos-config-management) which has Config Connector installed.

# Setup

this are from these [install steps for using workload identity](https://cloud.google.com/config-connector/docs/how-to/install-upgrade-uninstall#workload-identity).

```bash

export PROJECT_ID=[project id here]

gcloud config set project ${PROJECT_ID}
gcloud iam service-accounts create cnrm-system

gcloud projects add-iam-policy-binding ${PROJECT_ID}  --member="serviceAccount:cnrm-system@${PROJECT_ID}.iam.gserviceaccount.com"    --role="roles/owner"

gcloud iam service-accounts add-iam-policy-binding cnrm-system@${PROJECT_ID}.iam.gserviceaccount.com --member="serviceAccount:${PROJECT_ID}.svc.id.goog[cnrm-system/cnrm-controller-manager]" --role="roles/iam.workloadIdentityUser"

# and then edit the PROJECT_ID in the config in the repo
sed -i.bak 's/${PROJECT_ID?}/'${PROJECT_ID}'/' config-root-unstructured/install-bundle-workload-identity/0-cnrm-system.yaml
git commit -a -m'fixed appropriate project'   config-root/namespaces/cnrm-system/0-cnrm-system.yaml

```

