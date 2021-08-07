# Enable ACM features with Terraform

## Part 1

1. Clone this repo
1. Set variables that will be used in multiple commands:

    ```bash
    FOLDER_ID = [FOLDER]
    BILLING_ACCOUNT = [BILLING_ACCOUNT]
    PROJECT_ID = [PROJECT_ID]
    ```

1. Create project:

    ```bash
    gcloud auth login
    gcloud projects create $PROJECT_ID --name=$PROJECT_ID --folder=$FOLDER_ID
    gcloud alpha billing projects link $PROJECT_ID --billing-account $BILLING_ACCOUNT
    gcloud config set project $PROJECT_ID
    ```

1. Enable the Google Cloud APIs that will be used for this example and also enable the new configuration management feature for our project:

    ```bash
    gcloud services enable --project $PROJECT_ID  container.googleapis.com                \
                                                    gkehub.googleapis.com                 \
                                                    anthosconfigmanagement.googleapis.com

    gcloud beta container hub config-management enable  --project $PROJECT_ID
    ```

1. Create cluster using terraform using defaults other than the project:

    ```bash
    # continue in /terraform directory
    cd terraform

    export TF_VAR_project=$PROJECT_ID
    
    cd terraform
    terraform init
    terraform plan 
    terraform apply 
    ```
1. To verify things have sync'ed, you can use `gcloud` to check status:

    ```bash
    gcloud beta container hub config-management status --project $PROJECT_ID
    ```

1. To see wordpress itself, you can use the kubectl proxy to connect to the service:

    ```bash
    # get values from cluster that was created
    export CLUSTER_ZONE=`echo google_container_cluster.cluster.location | terraform console`
    export CLUSTER_NAME=`echo google_container_cluster.cluster.name | terraform console | sed s/\"//g`
    
    # then get creditials for it and proxy to the wordpress service to see it running
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID
    kubectl proxy --port 8888 &
    
    # curl or use the browser
    curl http://127.0.0.1:8888/api/v1/namespaces/default/services/wordpress/proxy/wp-admin/install.php
    
    # dont forget to foreground the proxy again to kill it
    fg # ctrl-c
    ```
