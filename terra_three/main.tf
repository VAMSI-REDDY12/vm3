resource "azurerm_resource_group" "task3_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "task3_vnet" {
  name                = "task3-vnet"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "task3_web_subnet" {
  name                 = "task3-web-tier-subnet"
  resource_group_name  = azurerm_resource_group.task3_rg.name
  virtual_network_name = azurerm_virtual_network.task3_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "task3_app_subnet" {
  name                 = "task3-app-tier-subnet"
  resource_group_name  = azurerm_resource_group.task3_rg.name
  virtual_network_name = azurerm_virtual_network.task3_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "task3_db_subnet" {
  name                 = "task3-db-tier-subnet"
  resource_group_name  = azurerm_resource_group.task3_rg.name
  virtual_network_name = azurerm_virtual_network.task3_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_security_group" "task3_web_nsg" {
  name                = "task3-web-nsg"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "task3_app_nsg" {
  name                = "task3-app-nsg"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name
}

resource "azurerm_network_security_group" "task3_db_nsg" {
  name                = "task3-db-nsg"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name
}

resource "azurerm_subnet_network_security_group_association" "task3_web_nsg_association" {
  subnet_id                 = azurerm_subnet.task3_web_subnet.id
  network_security_group_id = azurerm_network_security_group.task3_web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "task3_app_nsg_association" {
  subnet_id                 = azurerm_subnet.task3_app_subnet.id
  network_security_group_id = azurerm_network_security_group.task3_app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "task3_db_nsg_association" {
  subnet_id                 = azurerm_subnet.task3_db_subnet.id
  network_security_group_id = azurerm_network_security_group.task3_db_nsg.id
}

resource "azurerm_public_ip" "task3_lb_public_ip" {
  name                = "task3-lb-public-ip"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "task3_load_balancer" {
  name                = "task3-standard-lb"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "task3-lb-frontend"
    public_ip_address_id = azurerm_public_ip.task3_lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "task3_backend_pool" {
  loadbalancer_id = azurerm_lb.task3_load_balancer.id
  name            = "task3-web-backend-pool"
}

resource "azurerm_lb_probe" "task3_http_probe" {
  loadbalancer_id = azurerm_lb.task3_load_balancer.id
  name            = "task3-http-health-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "task3_http_rule" {
  loadbalancer_id                = azurerm_lb.task3_load_balancer.id
  name                           = "task3-http-load-balancing"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "task3-lb-frontend"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.task3_backend_pool.id
  ]

  probe_id = azurerm_lb_probe.task3_http_probe.id

  depends_on = [
    azurerm_lb_probe.task3_http_probe
  ]
}
resource "azurerm_network_interface" "task3_web_nic_1" {
  name                = "task3-web-vm-1-nic"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.task3_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "task3_web_nic_2" {
  name                = "task3-web-vm-2-nic"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.task3_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "task3_web_nic_3" {
  name                = "task3-web-vm-3-nic"
  location            = azurerm_resource_group.task3_rg.location
  resource_group_name = azurerm_resource_group.task3_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.task3_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "task3_web_nic_1_lb" {
  network_interface_id    = azurerm_network_interface.task3_web_nic_1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.task3_backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "task3_web_nic_2_lb" {
  network_interface_id    = azurerm_network_interface.task3_web_nic_2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.task3_backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "task3_web_nic_3_lb" {
  network_interface_id    = azurerm_network_interface.task3_web_nic_3.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.task3_backend_pool.id
}

resource "azurerm_windows_virtual_machine" "task3_web_vm_1" {
  name                = "task3-web-vm-1"
  resource_group_name = azurerm_resource_group.task3_rg.name
  location            = azurerm_resource_group.task3_rg.location
  size                = "Standard_F1ads_v7"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.task3_web_nic_1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    <powershell>
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Set-Content -Path C:\inetpub\wwwroot\index.html -Value "Welcome to Task 3 Web VM 1"
    </powershell>
  EOF
  )
}

resource "azurerm_windows_virtual_machine" "task3_web_vm_2" {
  name                = "task3-web-vm-2"
  resource_group_name = azurerm_resource_group.task3_rg.name
  location            = azurerm_resource_group.task3_rg.location
  size                = "Standard_F1ads_v7"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.task3_web_nic_2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    <powershell>
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Set-Content -Path C:\inetpub\wwwroot\index.html -Value "Welcome to Task 3 Web VM 2"
    </powershell>
  EOF
  )
}

resource "azurerm_windows_virtual_machine" "task3_web_vm_3" {
  name                = "task3-web-vm-3"
  resource_group_name = azurerm_resource_group.task3_rg.name
  location            = azurerm_resource_group.task3_rg.location
  size                = "Standard_F1ads_v7"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.task3_web_nic_3.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    <powershell>
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Set-Content -Path C:\inetpub\wwwroot\index.html -Value "Welcome to Task 3 Web VM 3"
    </powershell>
  EOF
  )
}
