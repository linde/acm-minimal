

this repo is a minimal [Anthos Config Management
repo](https://cloud.google.com/anthos-config-management/docs/how-to/repo) with
the addition of the [istio
operator](https://istio.io/docs/setup/install/standalone-operator/)

This was created using kustomize and [`kpt functions`](#TBD) as follows:

```bash

$ export TARGET=sink_target
$ mkdir ${TARGET}; chmod 777 ${TARGET}
$ curl --silent https://istio.io/operator.yaml |  
> kustomize config cat --wrap-kind=ResourceList --wrap-version=v1 |  
> docker run -u$(id -u) -i -v $(pwd)/${TARGET}:/tmp/${TARGET} gcr.io/kpt-functions/write-yaml:dev -d sink_dir=/tmp/${TARGET} -d overwrite=true > /dev/null

```

the resulting yaml directories were as follows:

```bash
$ find ${TARGET}
sink_target
sink_target/clusterrolebinding_istio-operator.yaml
sink_target/customresourcedefinition_istiocontrolplanes.install.istio.io.yaml
sink_target/istio-operator
sink_target/istio-operator/serviceaccount_istio-operator.yaml
sink_target/istio-operator/service_istio-operator-metrics.yaml
sink_target/istio-operator/deployment_istio-operator.yaml
sink_target/istio-operator/namespace.yaml
sink_target/clusterrole_istio-operator.yaml
$
```

and they're copied into their respective ACM locations in this commit.

