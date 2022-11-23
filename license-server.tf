resource "azurerm_resource_group" "license-server" {
  count    = var.licenseServer ? 1 : 0
  name     = "${var.infrastructurename}-license-server"
  location = var.location

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_subnet" "license-server-subnet" {
  count                = var.licenseServer ? 1 : 0
  name                 = "license-server-subnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.simphera-vnet.name
  address_prefixes     = ["10.0.98.0/24"]
}

# Virtual machine using Azure Bastion via private IP address
resource "azurerm_network_interface" "license-server-nic" {
  count               = var.licenseServer ? 1 : 0
  name                = "license-server-nic"
  resource_group_name = azurerm_resource_group.license-server[0].name
  location            = var.location

  ip_configuration {
    name                          = "ip-config-1"
    subnet_id                     = azurerm_subnet.license-server-subnet[0].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_network_security_group" "license-server-nsg" {
  count               = var.licenseServer ? 1 : 0
  name                = "license-server-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.license-server[0].name

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "licenseserver"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22350"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_network_interface_security_group_association" "ni-license-server-sga" {
  count                     = var.licenseServer ? 1 : 0
  network_interface_id      = azurerm_network_interface.license-server-nic.0.id
  network_security_group_id = azurerm_network_security_group.license-server-nsg.0.id
}


resource "azurerm_windows_virtual_machine" "license-server" {
  count                 = var.licenseServer ? 1 : 0
  resource_group_name   = azurerm_resource_group.license-server[0].name
  name                  = "license-server"
  location              = var.location
  size                  = "Standard_D2s_v4"
  admin_username        = local.license_server_secret["username"]
  admin_password        = local.license_server_secret["password"]
  network_interface_ids = [azurerm_network_interface.license-server-nic.0.id, ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

data "azurerm_key_vault" "keyvault" {
  count               = var.licenseServer ? 1 : 0
  name                = var.keyVault
  resource_group_name = var.keyVaultResourceGroup
}

# For reference see https://github.com/Azure/terraform-azurerm-diskencrypt
# To check the type_handler_version for actuality use `az vm extension image list-versions -l westeurope -p "Microsoft.Azure.Security" -n "AzureDiskEncryption"`
resource "azurerm_virtual_machine_extension" "azureDiskEncryption" {
  count                      = var.licenseServer ? 1 : 0
  name                       = "license-server-encryption"
  virtual_machine_id         = azurerm_windows_virtual_machine.license-server[0].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "2.2"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${data.azurerm_key_vault.keyvault[0].vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault[0].id}",					
        "KeyEncryptionKeyURL": "${var.encryptionKeyUrl}",
        "KekVaultResourceId": "${data.azurerm_key_vault.keyvault[0].id}",					
        "KeyEncryptionAlgorithm": "RSA-OAEP",
        "VolumeType": "All"
    }
SETTINGS

  tags = var.tags
}
