

## Overview

The follow steps can be used to create an example cluster (in this case, via [kind](https://kind.sigs.k8s.io/)) and register it with an Anthos Fleet to install ACM using a default repo and Policy Controller constraints.

We then deploy a self managed prometheus to take advantage of GCP Managed Prometheus and see Policy Controller metrics in the console.


## Create and register a cluster and install ACM

```bash

PROJECT=[stevenlinde-fleet-tf-mon-01]
KIND_CLUSTER_NAME=[acm-metrics]


MEMBERSHIP=kind-${KIND_CLUSTER_NAME}
kind create cluster --name=${KIND_CLUSTER_NAME}

gcloud container hub memberships register ${MEMBERSHIP} \
   --project=stevenlinde-fleet-tf-mon-01 \
   --context=kind-${KIND_CLUSTER_NAME} \
   --kubeconfig=${HOME}/.kube/config \
   --enable-workload-identity \
   --has-private-issuer

gcloud alpha container hub config-management enable --project=$PROJECT

gcloud alpha container hub config-management apply --config=acm-feature-config.yaml \
    --membership=${MEMBERSHIP} \
    --project=$PROJECT

```

## Setting up a GCP Service Account for Managed Prometheus

The section below comes from following instructions for [self deployed collection](https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-unmanaged):

```bash

gcloud iam service-accounts create gmp-test-sa

gcloud projects add-iam-policy-binding ${PROJECT}\
  --member=serviceAccount:gmp-test-sa@${PROJECT}.iam.gserviceaccount.com \
  --role=roles/monitoring.metricWriter

gcloud iam service-accounts keys create gmp-test-sa-key.json \
  --iam-account=gmp-test-sa@${PROJECT}.iam.gserviceaccount.com

kubectl -n gmp-test create secret generic gmp-test-sa \
  --from-file=key.json=gmp-test-sa-key.json

# update the values project-id and location in config-root/self-managed-prom.yaml
# within the gmp-test/prometheus-test ConfigMap

kubectl apply -f k8s-config/self-managed-prom.yaml

kubectl -n gmp-test create secret generic gmp-test-sa \
  --from-file=key.json=gmp-test-sa-key.json

# force a restart by removing the promotheus pod

kubectl delete -n gmp-test pod prometheus-test-0

# give it a sec, then check out the metrics on the managed prometheus dashboard
# https://pantheon.corp.google.com/monitoring/prometheus

```

In particular, the example [prometheus config](k8s-config/self-managed-prom.yaml) has been setup to scrape metrics that Anthos Config Management Policy Controller. it is configured to scapre pods that have the `monitored: "true"` label, as Policy Controler does.  You can see violations in the cluster via this query for `gatekeeper_violations` in the GCP [Managed Service for Prometheus](https://pantheon.corp.google.com/monitoring/prometheus?pageState=%7B%22promqlQuery%22:%22gatekeeper_violations%22%7D&). 


# Clean up

```bash

gcloud container hub memberships unregister   kind-acm-metrics --context=kind-${KIND_CLUSTER_NAME}
kind delete cluster --name=${KIND_CLUSTER_NAME}


```