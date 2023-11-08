terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
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

######### 3. Azure Linux Virtual Machine deployment #########


module "linux_vm" {
  source               = "./terraform-modules/virtual_machine"
  rg_name              = var.rg_name
  location             = var.rg_location
  vnet_name            = var.vnet_name
  vnet_adddress        = var.vnet_address
  subnet_nameList      = var.subnet_nameList
  subnet_addressList   = var.subnet_addressList
  pip_name             = var.pip_name
  pip_allocation       = var.pip_allocation
  vm_nic_name          = var.vm_nic_name
  ip_configuration     = var.ip_configuration
  nsg_name             = var.nsg_name
  vm_name              = var.vm_name
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
