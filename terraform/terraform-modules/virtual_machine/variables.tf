variable "rg_name" {
  type        = string
  default     = ""
  description = "Resource Group to be used for Virtual Machine Deployment"
}
variable "location" {
  type        = string
  default     = ""
  description = "Location of the Azure Virtual Machine"
}

variable "vnet_name" {
  type        = string
  default     = ""
  description = "Name of the vnet to create"
}
variable "vnet_adddress" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The address space that is used by the virtual network"
}

variable "subnet_nameList" {
  type        = list(string)
  default     = ["default"]
  description = "List of subnet names inside the Vnet"
}
variable "subnet_addressList" {
  type        = list(string)
  default     = ["10.0.0.0/24"]
  description = "The address prefix to use for the subnet."
}

variable "pip_name" {
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
variable "vm_nic_name" {
  type        = string
  default     = ""
  description = "Network Interface card name assigned to the Virtual Machine"
}
variable "ip_configuration" {
  type        = string
  default     = ""
  description = "IP configuration name for the Virtual Machine."
}

variable "nsg_name" {
  type        = string
  default     = ""
  description = "Network Security Group name"

}
variable "vm_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Machine to be created."
}
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
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.vm_os_disk_strg_type)
    error_message = "Unsupported disk type for Virtual machine. Possible options are Standard_LRS, StandardSSD_LRS and Premium_LRS."
  }
}

variable "vm_os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.vm_os_disk_caching)
    error_message = "Unsupported value for disk caching. Possible values are None, ReadOnly and ReadWrite."
  }

}
