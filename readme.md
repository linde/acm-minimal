

## Overview

The follow steps can be used to create an example cluster (in this case, via [kind](https://kind.sigs.k8s.io/)) and register it with an Anthos Fleet to install ACM with a repo that loads [kubevirt](https://kubevirt.io/). Essentially, this automates this turorial for kubevirt on [kind](https://kubevirt.io/quickstart_kind/).


## Create, register a cluster (and enable gateway RBAC), and install ACM

```bash

PROJECT=[stevenlinde-fleet-tf-mon-01]
KIND_CLUSTER_NAME=[acm-kubevirt]
KIND_CONTEXT_NAME=kind-${KIND_CLUSTER_NAME}
MEMBERSHIP=${KIND_CONTEXT_NAME}


kind create cluster --name=${KIND_CLUSTER_NAME}

gcloud container hub memberships register ${MEMBERSHIP} \
   --project=${PROJECT}  \
   --context=kind-${KIND_CLUSTER_NAME} \
   --kubeconfig=${HOME}/.kube/config \
   --enable-workload-identity \
   --has-private-issuer

## assuming you want to use connect with this, apply the following to setup RBAC
## this is odd because you can reach the cluster directly, but cool for remote admin

gcloud beta container fleet memberships generate-gateway-rbac  \
    --membership=${MEMBERSHIP} \
    --role=clusterrole/cluster-admin  \
    --users=$(gcloud config get account) \
    --project=${PROJECT}  \
    --kubeconfig=${HOME}/.kube/config \
    --context=${KIND_CONTEXT_NAME}  \
    --apply
    
gcloud alpha container hub config-management enable --project=$PROJECT

gcloud alpha container hub config-management apply --config=acm-feature-config.yaml \
    --membership=${MEMBERSHIP} \
    --project=$PROJECT


```

## Problem area

At the moment, on my enviroment at this point i can apply [vm.yaml](vm.yaml) directly, but it doesnt work when sync'ed via ACM/ConfigSync.


## Explore your new VM

Once the cluster has had a chance to sync and kubevirt to install, you can use `virtctl` as described in this [tutorial section](https://kubevirt.io/quickstart_kind/#virtctl) to start and interact with your VM.

```bash

kubectl get vm testvm -n kubevirt

virtctl start testvm -n kubevirt
kubectl get vmi testvm -n kubevirt

virtctl console  testvm -n kubevirt

# ...
# ^]

virtctl restart testvm -n kubevirt
virtctl stop testvm -n kubevirt


```

## Clean up

```bash

gcloud container hub memberships unregister   kind-acm-metrics --context=kind-${KIND_CLUSTER_NAME}
kind delete cluster --name=${KIND_CLUSTER_NAME}


```
