terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }

  required_version = ">= 0.15"
}
provider "azurerm" {
  features{}
}

#Creates resource group
resource "azurerm_resource_group" "main" {
    name = "zeb-tf-rg-eastus"
    location = "eastus"
}

#Creates virtual network
resource "azurerm_virtual_network" "main" {
  name                = "zeb-tf-vnet-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

#Create subnet
resource "azurerm_subnet" "main" {
    name = "zeb-tf-subnet-eastus"
    virtual_network_name = azurerm_virtual_network.main.name
    resource_group_name = azurerm_resource_group.main.name
    address_prefixes = ["10.0.0.0/24"]
}

#Create public ip
resource "azurerm_public_ip" "main" {
  name                = "zeb-tf-vm_pub_ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}


#Create network interface card
resource "azurerm_network_interface" "internal" {
    name ="zeb-tf-nic-int-eastus"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.main.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.main.id
    }
}

#Create network security group NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "zeb_tf_rdp_nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow_rdp_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


#Associate NSG with interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
    name = "zeb-vmeastus"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    size = "Standard_B1s"
    admin_username = "user.pirzada"
    admin_password = "Z@ib1234" 

    network_interface_ids = [
        azurerm_network_interface.internal.id
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2016-DataCenter"
        version = "latest"
    }
}

output "public_ip" {
        value = azurerm_public_ip.main.id
}
