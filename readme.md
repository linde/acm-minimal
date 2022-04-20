

## Overview

The follow steps can be used to create an example cluster (in this case, via [kind](https://kind.sigs.k8s.io/)) and register it with an Anthos Fleet to install ACM with a repo that loads [kubevirt](https://kubevirt.io/). Essentially, this automates this turorial for kubevirt on [kind](https://kubevirt.io/quickstart_kind/).


## Create and register a cluster and install ACM

```bash

PROJECT=[stevenlinde-fleet-tf-mon-01]
KIND_CLUSTER_NAME=[acm-kubevirt]

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

## Explore your new VM

TODO(stevenlinde) -- add details on `virtctl`.


## Clean up

```bash

gcloud container hub memberships unregister   kind-acm-metrics --context=kind-${KIND_CLUSTER_NAME}
kind delete cluster --name=${KIND_CLUSTER_NAME}


```