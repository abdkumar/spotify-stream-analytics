#=====================================================================================
#                   Reource Names
#=====================================================================================
rg_name                 = "spotify-stream-analytics"
rg_location             = "eastus"
keyvault_name           = "spotify-poc-keyvault"
databricks_name         = "poc-databricks"
vm_user_secret_name     = "vm-username" # secret name added in keyvault
vm_password_secret_name = "vm-password" # secret name added in keyvault
adls_name               = "spotifyadls"



#=====================================================================================
#                   Linux Virtual Machine CONFIGURATION
#=====================================================================================
pip_allocation = "Dynamic"
vm_size        = "Standard_B2ms"
vm_username    = "" ## Fetched from keyvault
vm_password    = "" ## Fetched from keyvault

vm_image_publisher = "Canonical"
vm_image_offer     = "0001-com-ubuntu-minimal-jammy"
vm_image_sku       = "minimal-22_04-lts-gen2"
vm_image_version   = "latest"

vm_os_disk_strg_type = "Standard_LRS"
vm_os_disk_caching   = "ReadWrite"


#=====================================================================================
#               KAFKA - VM - CONFIGURATION
#=====================================================================================
## VNET - SUBNET
kafka_vm_nic_name        = "kafka-vm-nic"
kafka_ip_configuration   = "kafka_ip_config"
kafka_nsg_name           = "kafka-vm-nsg"
kafka_vm_name            = "kafka-vm"
kafka_vnet_name          = "kafka-vm-vnet"
kafka_vnet_address       = "178.29.192.0/20"
kafka_subnet_nameList    = ["kafka-vm-snet"]
kafka_subnet_addressList = ["178.29.192.0/26"]
kafka_pip_name           = "kafka-vm-pip"



#=====================================================================================
#               SPARK - VM - CONFIGURATION
#=====================================================================================
spark_vm_nic_name        = "spark-vm-nic"
spark_ip_configuration   = "spark_ip_config"
spark_nsg_name           = "spark-vm-nsg"
spark_vm_name            = "spark-vm"
spark_vnet_name          = "spark-vm-vnet"
spark_vnet_address       = "10.0.0.0/16"
spark_subnet_nameList    = ["spark-vm-snet"]
spark_subnet_addressList = ["10.0.1.0/24"]
spark_pip_name           = "spark-vm-pip"
