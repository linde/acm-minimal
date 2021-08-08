# Enforce Cluster Guardrails with ACM Policy Controller

## Part 2

1. Set a variables for the project from [../part1]. We will re-use that project but create a new cluster since we cleaned up at the end of the first section.

    ```bash
    PROJECT_ID = [PROJECT_ID]
    ```

1. As before, cluster using terraform using defaults other than the project. The main difference in the [./terraform] files is that we turn on [PolicyController](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) and also install the build in [Policy Libary](https://cloud.google.com/anthos-config-management/docs/reference/constraint-template-library). 

    ```bash
    # continue in /terraform directory
    cd terraform

    terraform init 
    terraform plan -var=project=$PROJECT_ID
    terraform apply -var=project=$PROJECT_ID
    ```
1. To verify things have sync'ed and the policy controller is installed, you can again use `gcloud` to check status:

    ```bash
    gcloud beta container hub config-management status --project $PROJECT_ID
    ```
    Notice that in addition to the `Status` showing as `SYNCED` and the `Last_Synced_Token` matching the repo, there should also be a value of `INSTALLED` for `Policy_Controller`.


1. Now let's enforce some guardrails, in this case [CIS Benchmarks for Kubernetes](https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks).

TODO use `kpt` to get the bundle...
