## Pre Defined KV for storing secret
keyvault_name           = "spotify-keyvault1" #### We have to change as per env
rg_name                 = "spotify-stream-analytics"
rg_location             = "eastus"
vm_user_secret_name     = "vm-username"
vm_password_secret_name = "vm-password"

#=====================================================================================
#               KAFKA - VM - CONFIGURATION
#=====================================================================================
## VNET - SUBNET
vnet_name          = "kafka-vm-vnet"
vnet_address       = "178.29.192.0/20"
subnet_nameList    = ["kafka-vm-snet"]
subnet_addressList = ["178.29.192.0/26"]
pip_name           = "kafka-vm-pip"
pip_allocation     = "Dynamic"


### Linux Virtual Machine Deployment
vm_nic_name      = "kafka-vm-nic"
ip_configuration = "ip_config"
nsg_name         = "kafka-vm-nsg"
vm_name          = "kafka-vm"
vm_size          = "Standard_B2ms"
vm_username      = "" ## Fetched from KV.
vm_password      = "" ## Fetched from KV.

vm_image_publisher = "Canonical"
vm_image_offer     = "0001-com-ubuntu-minimal-jammy"
vm_image_sku       = "minimal-22_04-lts-gen2"
vm_image_version   = "latest"

vm_os_disk_strg_type = "Standard_LRS"
vm_os_disk_caching   = "ReadWrite"
