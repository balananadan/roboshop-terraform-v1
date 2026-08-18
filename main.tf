
resource "azurerm_public_ip" "frontend" {
  name                = "frontend"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"

  ip_configuration {
    name                          = "frontend-nic"
    subnet_id                     = "/subscriptions/5d6d5b42-ee4c-46d9-aed6-49fd22f441fe/resourceGroups/pomegranate/providers/Microsoft.Network/virtualNetworks/Allow_all/subnets/default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}

resource "azurerm_linux_virtual_machine" "frontend" {
  name                  = "frontend-vm"
  location              = "Denmark East"
  resource_group_name   = "denmark-east-rg"
  network_interface_ids = [azurerm_network_interface.frontend.id]
  size                  = "Standard_B1s"

  source_image_id = "/subscriptions/5d6d5b42-ee4c-46d9-aed6-49fd22f441fe/resourceGroups/pomegranate/providers/Microsoft.Compute/galleries/Pomo/images/1.1.0/versions/1.1.0"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_password = "bala@1234567"
  admin_username = "devops"

  disable_password_authentication = false

  secure_boot_enabled = true
  vtpm_enabled        = true

}

resource "azurerm_dns_a_record" "frontend" {
  name                = "frontend-dev"
  zone_name           = "piple.site"
  resource_group_name = "denmark-east-rg"
  ttl                 = 30
  records             = [azurerm_network_interface.frontend.private_ip_address]
}

