

super minimal configsync exploration


```bash

kind create cluster --name=mco

CS_VERSION=v.1.20.3
kubectl apply -f "https://github.com/GoogleContainerTools/kpt-config-sync/releases/download/${CS_VERSION}/config-sync-manifest.yaml"

kubectl apply -f ./configsync

kubectl get rootsync -n config-management-system

```

now, when this reconciles we should have just one configmap, `marker`.  the configmap named `dependant` does not appear since
it depends on another configmap named `other` which isnt on the cluster yet.

there is an error to this effect in the rootsync status:

```
 errorMessage: |-
   KNV2009: invalid object: "default_dependant__ConfigMap": invalid "config.kubernetes.io/depends-on" annotation: external dependency: /namespaces/default/ConfigMap/dependant -> /namespaces/default/ConfigMap/other

```

cool!

ideally, if you did something like `kubectl create configmap other`,
the error would go away and you'd then have three configmaps:
`marker`, 'other` and `dependant`. unfortunately, i think `depends-on`
is only looking within the resources configsync manages.

