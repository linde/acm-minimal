
To check out the policy lifecycle with a minimal repo:

## for authoring checks

```bash
nomos vet --path=config/root/
kpt fn run --dry-run config/ --image=gcr.io/config-management-release/policy-controller-validate:stable
```

## for audit checks

```
kubectl get constraint -o json | jq -C '.items[]|.kind,.status.violations' | less -R
```

## for admission checks

* [install ACM](https://cloud.google.com/anthos-config-management/docs/how-to/installing)
* apply this repo's [config-management.yaml](config-management.yaml) resource
* to get active enforcement, remove the `enforcementAction: dryrun` entry in [ns-should-have-cost-center.yaml](config/root/cluster/ns-should-have-cost-center.yaml#L6), commit and push the change.
* verify it syncs with `nomos status` and verify you've `SYNCED` the commit hash.
* see it in action with `kubectl create ns foo` (which should be rejected because it has no cost center label).

## to persist helm template output

* get a particular chart and expand it into a file in the respective [config/root/namespaces] directory

```bash
helm template  my-release bitnami/wordpress > config/root/namespaces/default/helm-bitnami-wordpress.yaml
git add !$
git commit -m'adding helm chart expansion'
git push

kubectl proxy &
open 'http://127.0.0.1:8001/api/v1/namespaces/default/services/my-release-wordpress:80/proxy/'

```





