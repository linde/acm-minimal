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
    gcloud auth application-default login
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
