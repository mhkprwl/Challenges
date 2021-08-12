# -
# - Create Resource Group
resource "azurerm_resource_group" "rg" {
  name = var.rgname
  location = var.location
}
###############################################################################################
# -
# - Create Virtual network
# -
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}
###############################################################################################
# -
# - Create Subnets
# -
resource "azurerm_subnet" "websubnet" {
  name                                           = var.websubnetname
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = azurerm_resource_group.rg.name
  address_prefixes                               = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appsubnet" {
  name                                           = var.appsubnetname
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = azurerm_resource_group.rg.name
  address_prefixes                               = ["10.0.2.0/24"]
}
###############################################################################################
# -
# - Create Network Security Groups - Association with Subnets - Rules
# -
resource "azurerm_network_security_group" "webnsg" {
  name                = var.webnsgname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "appnsg" {
  name                = var.appnsgname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "web-assc" {
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}

resource "azurerm_subnet_network_security_group_association" "app-assc" {
  subnet_id                 = azurerm_subnet.appsubnet.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}

resource "azurerm_network_security_rule" "webnsgrule1" {
  name                        = "IBA-AzureLoadBalancer"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_network_security_rule" "webnsgrule2" {
  name                        = "IBA-SSH-Inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_network_security_rule" "webnsgrule3" {
  name                        = "IBD-All"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_network_security_rule" "appnsgrule1" {
  name                        = "IBA-Web-SSH-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.appnsg.name
}

resource "azurerm_network_security_rule" "appnsgrule2" {
  name                        = "IBD-All"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.appnsg.name
}
###############################################################################################
# -
# - Create Azure Load Balancer - Backend Pool - LB rules - Health Probes - Outbound Rules
# -

resource "azurerm_public_ip" "lbip" {
  name                = var.lbpip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# - Resource
resource "azurerm_lb" "lb" {
  name                = var.lbname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                          = var.frontend_name
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.lbip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lbbp" {
  name                = "webvmbackendpool"
  loadbalancer_id = azurerm_lb.lb.id
  depends_on      = [azurerm_lb.lb]
}

resource "azurerm_lb_outbound_rule" "lboutbound" {
  resource_group_name     = azurerm_resource_group.rg.name
  name                    = "${var.lbname}-outboundrule"
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp.id

  frontend_ip_configuration {
    name = var.frontend_name
  }

  loadbalancer_id = azurerm_lb.lb.id
  depends_on      = [azurerm_lb.lb]
}

resource "azurerm_lb_probe" "sshhp" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.lbname}-ssh-hp"
  protocol            = "Tcp"
  port                = 22
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "sshlbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "${var.lbname}-ssh-lbrule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = var.frontend_name
  enable_floating_ip             = false
  disable_outbound_snat          = true
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lbbp.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.sshhp.id
  depends_on                     = [azurerm_lb_probe.sshhp]
}

###############################################################################################

data "azurerm_client_config" "current" {}

# -
# - Create Azure Keyvault - Access Policy - Secrets
# -

resource "azurerm_key_vault" "poc" {
  name                = var.kvname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
}

resource "tls_private_key" "webvm" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "appvm" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "webvm" {
  name         = "${var.webvmnic}-ssh-key"
  value        = tls_private_key.webvm.private_key_pem
  key_vault_id = azurerm_key_vault.poc.id
  depends_on = [azurerm_key_vault_access_policy.policy]
}

resource "azurerm_key_vault_secret" "appvm" {
  name         = "${var.appvmnic}-ssh-key"
  value        = tls_private_key.appvm.private_key_pem
  key_vault_id = azurerm_key_vault.poc.id
  depends_on = [azurerm_key_vault_access_policy.policy]
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id              = azurerm_key_vault.poc.id
  tenant_id                 = var.tenant_id
  object_id                 = var.object_id
  secret_permissions        = ["Get", "List","Set"]
  key_permissions           = ["Get","List","Update", "Create","Import","Decrypt","Encrypt","UnwrapKey","WrapKey"]
  certificate_permissions   = ["Get","List","Create","Import","Update"]
  storage_permissions       = []
}

###############################################################################################
# -
# - Create Virtual Machine Nics
# -

resource "azurerm_network_interface" "webvmnic" {
  name                = var.webvmnic
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "appvmnic" {
  name                = var.appvmnic
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "app-internal"
    subnet_id                     = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
###############################################################################################

# -
# - Create Linux Virtual Machine
# -

resource "azurerm_linux_virtual_machine" "webvm" {
  name                = var.webvmname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.webvmnic.id,
  ]
  admin_username      = var.vm_admin_username
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.webvm.public_key_openssh
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  lifecycle {
    ignore_changes = [
      admin_ssh_key
    ]
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "appvm" {
  name                = var.appvmname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.appvmnic.id,
  ]
  admin_username      = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.appvm.public_key_openssh
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  lifecycle {
    ignore_changes = [
      admin_ssh_key
    ]
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
###############################################################################################
# -
# - Associating WebVM VM Load Balancer Backend Pool
# -

resource "azurerm_network_interface_backend_address_pool_association" "webvmassociation" {
  network_interface_id            = azurerm_network_interface.webvmnic.id
  ip_configuration_name           = "web-internal"
  backend_address_pool_id         = azurerm_lb_backend_address_pool.lbbp.id
}
###############################################################################################

# -
# - Creating MYSQL PaaS DB
# -

resource "random_string" "mysql" {
  length           = 32
  special          = true
  override_special = "/@"
}

resource "azurerm_mysql_server" "mysql" {
  name                = var.sqlsrvname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.mysql_sku_name

  storage_mb            = 5120
  backup_retention_days = 30
  geo_redundant_backup_enabled = false
  auto_grow_enabled     = false

  administrator_login          = var.db_administrator_login_name
  administrator_login_password = random_string.mysql.result
  version                      = var.mysql_version
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  lifecycle {
    ignore_changes = [
      administrator_login_password
    ]
  }
}

resource "azurerm_mysql_database" "mysql" {
  name                = var.sqlsrvdbname
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  depends_on = [azurerm_mysql_server.mysql]
}

# Add admin login password to Key Vault secrets
resource "azurerm_key_vault_secret" "mysql_keyvault_secret" {
  name         = "${var.sqlsrvname}-adminpassword"
  value        = azurerm_mysql_server.mysql.administrator_login_password
  key_vault_id = azurerm_key_vault.poc.id

  depends_on = [azurerm_mysql_server.mysql]
}
