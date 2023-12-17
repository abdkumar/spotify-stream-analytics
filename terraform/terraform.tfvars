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
#               airflow - VM - CONFIGURATION
#=====================================================================================
airflow_vm_nic_name        = "airflow-vm-nic"
airflow_ip_configuration   = "airflow_ip_config"
airflow_nsg_name           = "airflow-vm-nsg"
airflow_vm_name            = "airflow-vm"
airflow_vnet_name          = "airflow-vm-vnet"
airflow_vnet_address       = "10.0.0.0/16"
airflow_subnet_nameList    = ["airflow-vm-snet"]
airflow_subnet_addressList = ["10.0.1.0/24"]
airflow_pip_name           = "airflow-vm-pip"
