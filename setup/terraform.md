# Using Terraform to Create Azure Resources
This document provides a guide for using Terraform to create the following Azure resources:

# Installation
To install Terraform, find the [appropriate package](https://developer.hashicorp.com/terraform/install) for your system and download it as a zip archive.

After downloading Terraform, unzip the package. Terraform runs as a single binary named `terraform`. Any other files in the package can be safely removed and Terraform will still function.

Finally, make sure that the terraform binary is available on your `PATH`. This process will differ depending on your operating system.

[Reference](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

# Environment Variable Configuration
To enable Terraform to create resources on your Azure environment, we've defined several variables in the `terraform/variables.tf` file. These variables store the credentials for your Azure Service Principal:

- azure_client_secret: This variable holds the secret key associated with your Service Principal.
- azure_client_id: This variable stores the application (client) ID of your Service Principal.
- azure_tenant_id: This variable identifies the Azure Active Directory tenant your Service Principal belongs to.
- azure_subscription_id: This variable specifies the ID of the Azure subscription you want Terraform to use.

Environment variables can be used to set variables. The environment variables must be in the format `TF_VAR_name` and this will be checked last for a value. 

Configure environment variables: Set the following environment variables to access your Service Principal credentials:

- `TF_VAR_azure_client_secret`
- `TF_VAR_azure_client_id`
- `TF_VAR_azure_tenant_id`
- `TF_VAR_azure_subscription_id`

These variables are essential for Terraform to authenticate with Azure and execute the resource creation process. Make sure you populate them with the corresponding values from your Service Principal configuration.

[Reference](https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_var_name)

# Azure Resources

## Virtual Machines:
**Configuration**: Linux VM , Ubunut 22 LTS, Standard_B2ms	(vCPU=2, RAM=8GB, SSD=16GB)
- kafka-vm: Runs a Kafka server and produces Kafka events using Python, run Spark streaming job to process stream events
- airflow-vm: Orchestrates Databricks CDC job and DBT models using Airflow.

## Storage Account:
**Configuration**: Standard LRS with hierarchical namespace enabled (Azure Data Lakge Storage Gen 2)

Used to store Spark stream processed data in Delta format.

## Databricks:
**Configuration**: Standard pricing tier workspace

Used to create a Delta change data capture job.

# Terraform Commands

## Update Terraform Variables:

Open the `terraform/terraform.tfvars` file & update the resource, keyvault variable names as per your requirements.

## Initialize Terraform:
Open a terminal and navigate to your Terraform directory (`spotify-stream-analytics/terraform`). Run the following command to initialize Terraform:

```bash
terraform init
```

## Plan Terraform Configuration:
Run the following command to preview the changes Terraform will make:
```bash
terraform plan -out "tfplan"
```
## Apply Terraform Configuration:
Review the plan carefully. If everything looks good, run the following command to apply the configuration and create the resources:

```bash
terraform apply "tfplan"
```
# Verify Resources:
After applying the configuration, log in to the Azure portal and verify that your VMs, storage account, and Databricks workspace have been created successfully.


# Destroy Resources
Convenient way to destroy all remote objects managed by a particular Terraform configuration
```bash
terraform destroy
```