# Network Interface for the VM
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Public IP for the VM
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Associate NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-vm"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  size                = "Standard_B2s"

  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234!"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = "testing"
  }
}

# Output the VM's public IP
output "vm_public_ip" {
  value       = azurerm_public_ip.example.ip_address
  description = "Public IP address of the VM"
}

output "vm_private_ip" {
  value       = azurerm_network_interface.example.private_ip_address
  description = "Private IP address of the VM"
}

output "vm_admin_username" {
  value       = "azureuser"
  description = "Admin username for Windows VM"
}

output "vm_admin_password" {
  value       = "P@ssw0rd1234!"
  description = "Admin password for Windows VM"
  sensitive   = true
}
