variable "azure_subscription_id" {
  description = "Subscription Id of the Service Principal"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Tenant Id of the Service Principal"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Client Id of the Service Principal"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Client Secret of the Service Principal"
  type        = string
  sensitive   = true
}


variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "rg_location" {
  description = "Location of the Resource Group"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "adls_name" {
  description = "Name of the Storage Account"
  type        = string
}

variable "databricks_name" {
  description = "Name of the Databricks Workspace"
  type        = string
}


### VNET Module Variables Start ###

variable "kafka_vnet_name" {
  type    = string
  default = ""
}
variable "kafka_vnet_address" {
  type    = string
  default = ""
}
variable "kafka_subnet_nameList" {
  type    = list(string)
  default = [""]
}
variable "kafka_subnet_addressList" {
  type    = list(string)
  default = [""]
}

variable "airflow_vnet_name" {
  type    = string
  default = ""
}
variable "airflow_vnet_address" {
  type    = string
  default = ""
}
variable "airflow_subnet_nameList" {
  type    = list(string)
  default = [""]
}
variable "airflow_subnet_addressList" {
  type    = list(string)
  default = [""]
}



#### Variables for Linux Virtual Module defined here ####

# Kafka VM variables
variable "kafka_pip_name" {
  type        = string
  default     = ""
  description = "Name of the Public IP instance assigned to the Virtual Machine"
}



variable "kafka_vm_nic_name" {
  type        = string
  default     = ""
  description = "Network Interface card name assigned to the Virtual Machine"
}

variable "kafka_nsg_name" {
  type        = string
  default     = ""
  description = "Network Security Group name"

}
variable "kafka_ip_configuration" {
  type        = string
  default     = ""
  description = "IP configuration name for the Virtual Machine."
}
variable "kafka_vm_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Machine to be created."
}

# airflow VM variables

variable "airflow_pip_name" {
  type        = string
  default     = ""
  description = "Name of the Public IP instance assigned to the Virtual Machine"
}
variable "pip_allocation" {
  type    = string
  default = ""
  validation {
    condition     = contains(["static", "dynamic"], lower(var.pip_allocation))
    error_message = "Public IP assignment can be either Static or Dynamic. Please correct your selection."
  }
  description = "Public IP assignment type"
}
variable "airflow_vm_nic_name" {
  type        = string
  default     = ""
  description = "Network Interface card name assigned to the Virtual Machine"
}

variable "airflow_nsg_name" {
  type        = string
  default     = ""
  description = "Network Security Group name"

}
variable "airflow_ip_configuration" {
  type        = string
  default     = ""
  description = "IP configuration name for the Virtual Machine."
}
variable "airflow_vm_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Machine to be created."
}

# Common VM variables
variable "vm_size" {
  type        = string
  default     = ""
  description = "Virtual Machine \"Size\"SKU\" to be created such as : Standard_F2"
}
variable "vm_username" {
  type        = string
  default     = ""
  description = "Username for Azure Virtual Machine"
}
variable "vm_password" {
  type        = string
  default     = ""
  description = "Password for Azure Virtual Machine"
}

variable "vm_image_publisher" {
  type        = string
  default     = ""
  description = "Azure Virtual Machine Publisher such as : MicrosoftWindowsServer."
}
variable "vm_image_offer" {
  type        = string
  default     = ""
  description = "Image Offer for the Publisher selected. Available options can be : WindowsServer."
}
variable "vm_image_sku" {
  type        = string
  default     = ""
  description = "Image Version or SKU for the publisher you have chosen. Such as 2019-Datacenter, 2016-Datacenter, etc."
}
variable "vm_image_version" {
  type        = string
  default     = ""
  description = "This is the Image Version of the SKU that you have selected. Usually the selected option is \"Latest\". "
}
variable "vm_os_disk_strg_type" {
  type        = string
  default     = "Standard_LRS"
  description = "OS Disk Storage Type. Possible options are Standard_LRS, StandardSSD_LRS and Premium_LRS."
}

variable "vm_os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."

}


variable "vm_user_secret_name" {
  type        = string
  description = "Secret name in Keyvault where virtual machine user name is stored."
}

variable "vm_password_secret_name" {
  type        = string
  description = "Secret name in Keyvault where virtual machine user password is stored."
}

# variable "vm_subnetid" {
#   type        = string
#   description = "Subnet Id for the Virtual machine. This will be fetched from Network Module."
# }
