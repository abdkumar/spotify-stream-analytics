terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.79.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "1.3.1"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}

# resource "azurerm_resource_group" "app_grp" {
#   name     = var.rg_name
#   location = var.rg_location

# }


#############################################################################
resource "azurerm_storage_account" "storage" {
  name                     = var.adls_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  
  
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

#############################################################################
resource "azurerm_databricks_workspace" "azure_db" {
  name                        = var.databricks_name
  resource_group_name         = var.rg_name
  location                    = var.rg_location
  sku                         = "standard"
  managed_resource_group_name = "${var.databricks_name}-workspace-rg"
}

#############################################################################
### Data source for KV - to retrive the secrets from KV, declaring the existing KV details.
data "azurerm_key_vault" "kv_name" {
  name                = var.keyvault_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault_secret" "virtual_machine_user" {
  name         = var.vm_user_secret_name
  key_vault_id = data.azurerm_key_vault.kv_name.id
  
}

data "azurerm_key_vault_secret" "virtual_machine_passwd" {
  name         = var.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv_name.id
}

#############################################################################

######### Azure Linux Virtual Machine deployment #########

module "kafka_vm" {
  source               = "./terraform-modules/virtual_machine"
  rg_name              = var.rg_name
  location             = var.rg_location
  vnet_name            = var.kafka_vnet_name
  vnet_adddress        = var.kafka_vnet_address
  subnet_nameList      = var.kafka_subnet_nameList
  subnet_addressList   = var.kafka_subnet_addressList
  pip_name             = var.kafka_pip_name
  pip_allocation       = var.pip_allocation
  vm_nic_name          = var.kafka_vm_nic_name
  ip_configuration     = var.kafka_ip_configuration
  nsg_name             = var.kafka_nsg_name
  vm_name              = var.kafka_vm_name
  vm_size              = var.vm_size
  vm_username          = data.azurerm_key_vault_secret.virtual_machine_user.value
  vm_password          = data.azurerm_key_vault_secret.virtual_machine_passwd.value
  vm_image_publisher   = var.vm_image_publisher
  vm_image_offer       = var.vm_image_offer
  vm_image_sku         = var.vm_image_sku
  vm_image_version     = var.vm_image_version
  vm_os_disk_strg_type = var.vm_os_disk_strg_type
  vm_os_disk_caching   = var.vm_os_disk_caching
}

module "airflow_vm" {
  source               = "./terraform-modules/virtual_machine"
  rg_name              = var.rg_name
  location             = var.rg_location
  vnet_name            = var.airflow_vnet_name
  vnet_adddress        = var.airflow_vnet_address
  subnet_nameList      = var.airflow_subnet_nameList
  subnet_addressList   = var.airflow_subnet_addressList
  pip_name             = var.airflow_pip_name
  pip_allocation       = var.pip_allocation
  vm_nic_name          = var.airflow_vm_nic_name
  ip_configuration     = var.airflow_ip_configuration
  nsg_name             = var.airflow_nsg_name
  vm_name              = var.airflow_vm_name
  vm_size              = var.vm_size
  vm_username          = data.azurerm_key_vault_secret.virtual_machine_user.value
  vm_password          = data.azurerm_key_vault_secret.virtual_machine_passwd.value
  vm_image_publisher   = var.vm_image_publisher
  vm_image_offer       = var.vm_image_offer
  vm_image_sku         = var.vm_image_sku
  vm_image_version     = var.vm_image_version
  vm_os_disk_strg_type = var.vm_os_disk_strg_type
  vm_os_disk_caching   = var.vm_os_disk_caching
}