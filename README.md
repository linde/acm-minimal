
To check out the policy lifecycle with a minimal repo:

## for authoring checks

```bash
nomos vet --path=config-root/
kpt fn run --dry-run config-root/ --image=gcr.io/config-management-release/policy-controller-validate:stable
```

## for admission checks

* [install ACM](https://cloud.google.com/anthos-config-management/docs/how-to/installing)
* apply this repo's [config-management.yaml](config-management.yaml) resource
* to get active enforcement, remove the `enforcementAction: dryrun` entry in [ns-should-have-cost-center.yaml](config-root/cluster/ns-should-have-cost-centere.yaml)


## for audit checks

```
kubectl get constraint -o json | jq -C '.items[]|.kind,.status.violations' | less -R
```


