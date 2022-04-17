

## register a cluster and install ACM

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

cleaning up and parameterizing the instructions for [self deployed collection](https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-unmanaged):

```bash

gcloud iam service-accounts create gmp-test-sa

gcloud projects add-iam-policy-binding ${PROJECT}\
  --member=serviceAccount:gmp-test-sa@${PROJECT}.iam.gserviceaccount.com \
  --role=roles/monitoring.metricWriter

gcloud iam service-accounts keys create gmp-test-sa-key.json \
  --iam-account=gmp-test-sa@${PROJECT}.iam.gserviceaccount.com

kubectl  apply -f k8s-config/00-ns.yaml

kubectl -n gmp-test create secret generic gmp-test-sa \
  --from-file=key.json=gmp-test-sa-key.json

# update the values project-id and location in config-root/01-prometheus.yaml
# within the gmp-test/prometheus-test ConfigMap

kubectl apply -f k8s-config/01-prometheus.yaml

# check out the metrics on the managed prometheus dashboard
# https://pantheon.corp.google.com/monitoring/prometheus



```