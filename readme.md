

super minimal configsync exploration


```bash

kind create cluster --name=mco

CS_VERSION=v.1.20.3
kubectl apply -f "https://github.com/GoogleContainerTools/kpt-config-sync/releases/download/${CS_VERSION}/config-sync-manifest.yaml"

kubectl apply -f ./configsync

kubectl get rootsync -n config-management-system

```