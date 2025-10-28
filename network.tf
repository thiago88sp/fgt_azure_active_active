###########################################################################################
#                                 Network Resources                                       #
###########################################################################################

// Vnets

resource "azurerm_virtual_network" "res-40" {
  address_space       = [var.vnetcidr]
  location            = var.location
  name                = "Vnet-Customer-Sdwan"
  resource_group_name = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
}

#data "azurerm_virtual_network" "subnet1" {
#  name                = "production"
#  resource_group_name = "networking"
#}

// Subnets

resource "azurerm_subnet" "publicsubnet" {
  address_prefixes     = [var.publiccidr]
  name                 = "FortinetExternalSubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.res-40.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.res-40,
  ]
}

resource "azurerm_subnet" "privatesubnet" {
  address_prefixes     = [var.privatecidr]
  name                 = "FortinetInternalSubnet"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = azurerm_virtual_network.res-40.name
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_virtual_network.res-40,
  ]
}

// Load Balancers

#------------------------------ ELB ----------------------------------#

resource "azurerm_lb" "externalLB" {
  location            = var.location
  name                = "FGT-Customer-ExternalLoadBalancer"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags = {
    Source = "terraform"
  }
  frontend_ip_configuration {
    name                 = "FGT-Customer-ELB-FortinetExternalSubnet-FrontEnd"
    public_ip_address_id = azurerm_public_ip.ClusterPublicIP.id
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

// ELB - Backend Address Pool

resource "azurerm_lb_backend_address_pool" "res-8" {
  loadbalancer_id = azurerm_lb.externalLB.id
  name            = "FGT-Customer-ELB-FortinetExternalSubnet-BackEnd"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb.externalLB,
  ]
}

// ELB - Probe

resource "azurerm_lb_probe" "externalLB-rule-probe" {
  loadbalancer_id = azurerm_lb.externalLB.id
  name            = "lbprobe"
  protocol        = "Http"
  request_path    = "/"
  port            = 8008
}

// ELB - Rule

resource "azurerm_lb_rule" "externalLB-rule" {
  loadbalancer_id                = azurerm_lb.externalLB.id
  name                           = "PublicLBRule-FE1-http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "FGT-Customer-ELB-FortinetExternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.res-8.id]
  probe_id                       = azurerm_lb_probe.externalLB-rule-probe.id
}

resource "azurerm_lb_rule" "externalLB-rule-2" {
  loadbalancer_id                = azurerm_lb.externalLB.id
  name                           = "PublicLBRule-FE1-udp10551"
  protocol                       = "Udp"
  frontend_port                  = 10551
  backend_port                   = 10551
  frontend_ip_configuration_name = "FGT-Customer-ELB-FortinetExternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.res-8.id]
  probe_id                       = azurerm_lb_probe.externalLB-rule-probe.id
}

// Inbound NAT Rule

resource "azurerm_lb_nat_rule" "inbount_nat_rule" {
  resource_group_name            = azurerm_resource_group.res-0.name
  loadbalancer_id                = azurerm_lb.externalLB.id
  name                           = "InboundNATRule"
  protocol                       = "Tcp"
  frontend_port_start            = 8443
  frontend_port_end              = 8546
  backend_port                   = 8443
  backend_address_pool_id        = azurerm_lb_backend_address_pool.res-8.id
  frontend_ip_configuration_name = "FGT-Customer-ELB-FortinetExternalSubnet-FrontEnd"
}

#------------------------------ ILB ----------------------------------#

resource "azurerm_lb" "internalLB" {
  location            = var.location
  name                = "FGT-Customer-InternalLoadBalancer"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags = {
    Source = "terraform"
  }
  frontend_ip_configuration {
    name      = "FGT-Customer-ILB-FortinetInternalSubnet-FrontEnd"
    subnet_id = azurerm_subnet.privatesubnet.id

  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}

// ILB - Backend Address Pool

resource "azurerm_lb_backend_address_pool" "res-10" {
  loadbalancer_id = azurerm_lb.internalLB.id
  name            = "FGT-Customer-ILB-FortinetInternalSubnet-BackEnd"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb.internalLB,
  ]
}

// ILB - Probe

resource "azurerm_lb_probe" "internalLB-rule-probe" {
  loadbalancer_id = azurerm_lb.internalLB.id
  name            = "lbprobe"
  protocol        = "Http"
  request_path    = "/"
  port            = 8008
}

// ILB - Rule

resource "azurerm_lb_rule" "internalLB-rule" {
  loadbalancer_id                = azurerm_lb.internalLB.id
  name                           = "lbruleFE2all"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "FGT-Customer-ILB-FortinetInternalSubnet-FrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.res-10.id]
  probe_id                       = azurerm_lb_probe.internalLB-rule-probe.id
}


#------------------------------ Network Interfaces ----------------------------------#

// VM Active

resource "azurerm_network_interface" "activeport1" {
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true
  location                       = var.location
  name                           = "FGT-Customer01-Nic1"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport1

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.publicsubnet,
  ]
}

resource "azurerm_network_interface" "activeport2" {
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true
  location                       = var.location
  name                           = "FGT-Customer01-Nic2"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport2
  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.privatesubnet,
  ]
}

// VM Passive

resource "azurerm_network_interface" "fgtvm2port1" {
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true
  location                       = var.location
  name                           = "FGT-Customer02-Nic1"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fgtvm2port1

  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.publicsubnet,
  ]
}

resource "azurerm_network_interface" "fgtvm2port2" {
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true
  location                       = var.location
  name                           = "FGT-Customer02-Nic2"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fgtvm2port2


  }
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_subnet.privatesubnet,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "res-12" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-8.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.activeport1.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.res-8,
    azurerm_network_interface.activeport1,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-13" {
  network_interface_id      = azurerm_network_interface.activeport1.id
  network_security_group_id = azurerm_network_security_group.res-31.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport1,
    azurerm_network_security_group.res-31,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "res-15" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-10.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.activeport2.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.res-10,
    azurerm_network_interface.activeport2,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-16" {
  network_interface_id      = azurerm_network_interface.activeport2.id
  network_security_group_id = azurerm_network_security_group.res-31.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.activeport2,
    azurerm_network_security_group.res-31,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "res-22" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-8.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.fgtvm2port1.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.res-8,
    azurerm_network_interface.fgtvm2port1,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-23" {
  network_interface_id      = azurerm_network_interface.fgtvm2port1.id
  network_security_group_id = azurerm_network_security_group.res-31.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.fgtvm2port1,
    azurerm_network_security_group.res-31,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "res-25" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-10.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.fgtvm2port2.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_lb_backend_address_pool.res-10,
    azurerm_network_interface.fgtvm2port2,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-26" {
  network_interface_id      = azurerm_network_interface.fgtvm2port2.id
  network_security_group_id = azurerm_network_security_group.res-31.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.fgtvm2port2,
    azurerm_network_security_group.res-31,
  ]
}

resource "azurerm_network_security_group" "res-31" {
  location            = var.location
  name                = "FGT-Customer-NSG"
  resource_group_name = azurerm_resource_group.res-0.name
  tags = {
    Source = "terraform"
  }
}
resource "azurerm_network_security_rule" "res-32" {
  access                      = "Allow"
  description                 = "Allow all in"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowAllInbound"
  network_security_group_name = "FGT-Customer-NSG"
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.res-0.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_security_group.res-31,
  ]
}
resource "azurerm_network_security_rule" "res-33" {
  access                      = "Allow"
  description                 = "Allow all out"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Outbound"
  name                        = "AllowAllOutbound"
  network_security_group_name = "FGT-Customer-NSG"
  priority                    = 105
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.res-0.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_security_group.res-31,
  ]
}

resource "azurerm_public_ip" "ClusterPublicIP" {
  allocation_method   = "Static"
  domain_name_label   = "fgt-customer"
  location            = var.location
  name                = "FGT-Customer-FGT-PIP"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  tags = {
    Source = "terraform"
  }
  zones = ["1", "2", "3"]
}



