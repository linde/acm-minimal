
## Overview

this repo is a minimal [Anthos Config Management
repo](https://cloud.google.com/anthos-config-management/docs/how-to/repo) (ACM) with
the addition of the [istio
operator](https://istio.io/docs/setup/install/standalone-operator/)


## Istio resources

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


## Policy Controller resources

This repo also has resources which enable [ACM Policy
Controller](https://cloud.google.com/anthos-config-management/docs/how-to/installing-policy-controller)
enforcement. In this case, we've enabled the [`ConfigManagement`
resource](config-management.yaml) to enable the policy controller and enabled a
constraint using the provided [Constraint Template
bundle](https://cloud.google.com/anthos-config-management/docs/how-to/installing-policy-controller#managing-constraint-template-library)
to enforce a constraint on Namespace resources that requires [istio side car
injection](https://istio.io/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection).

## Violations

The constraint example is run in an Audit mode which captures violations, but
does not otherwise impact admission. This is enabled by specifying enforcement
of 'dryrun' for the constraint (see example,
[istio-enabled-namespaces-constraint](config-root/cluster/istio-enabled-namespaces-constraint.yaml#L7).

Audit violations are captured in the constraint resource. To see them simply via the CLI, try the following:

```bash
$ kubectl get k8srequiredlabels istio-enabled-namespaces-constraint -o json | jq .status.violations

```






