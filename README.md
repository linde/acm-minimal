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

1. Enable multiple APIs that will be used for this example:

    ```bash
    gcloud services enable compute.googleapis.com \
                           cloudresourcemanager.googleapis.com \
                           iam.googleapis.com \
                           container.googleapis.com \
                           gkehub.googleapis.com \
                           anthosconfigmanagement.googleapis.com \
                           sqladmin.googleapis.com
    ```

1. Create cluster using terraform:

    ```bash
    gcloud auth application-default login
    
    # continue in /terraform directory
    cd terraform
    terraform init
    terraform plan -var="project=$PROJECT_ID" \
                   -var="sync_repo=https://github.com/linde/acm-minimal.git" \
                   -var="sync_branch=minimal-tf-hub-wordpress" \
                   -var="policy_dir=config-root"

    terraform apply -var="project=$PROJECT_ID" \
                   -var="sync_repo=https://github.com/linde/acm-minimal.git" \
                   -var="sync_branch=minimal-tf-hub-wordpress" \
                   -var="policy_dir=config-root"
    ```
