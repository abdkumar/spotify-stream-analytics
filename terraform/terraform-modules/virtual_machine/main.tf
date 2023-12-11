# resource "azurerm_resource_group" "rg" {
#   name     = var.rg_name
#   location = var.location
# }

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_adddress]
  location            = var.location
  resource_group_name = var.rg_name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_nameList[0]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rg_name
  address_prefixes     = var.subnet_addressList
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = var.pip_allocation
}


# Create network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = var.vm_nic_name
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                          = var.ip_configuration
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.pip_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    access                     = "Allow"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.vm_nic.private_ip_address
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}


resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.vm_name
  resource_group_name             = var.rg_name
  location                        = var.location
  depends_on = [ azurerm_network_interface_security_group_association.association ]
  size                            = var.vm_size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  os_disk {
    storage_account_type = var.vm_os_disk_strg_type
    caching              = var.vm_os_disk_caching
  }


}
