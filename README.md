

## Minimal ACM wordpress repo with some PSP violations.


To run it, do the following from the git root directory:

```bash

# get the packages for the bundle you are after
kpt get http://path.to/bundle policy

# flatten the ACM directory if not unstructured
# TODO

kpt fn run --dry-run \
    --image=gcr.io/config-management-release/policy-controller-validate:stable \ 
    config-root/

```

