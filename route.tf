resource "azurerm_route_table" "internal" {
  name                = "InternalRouteTable1"
  location            = azurerm_resource_group.res-0.location
  resource_group_name = azurerm_resource_group.res-0.name
}

resource "azurerm_route" "default" {
  #depends_on             = [azurerm_virtual_machine.activefgtvm2]
  depends_on             = [azurerm_linux_virtual_machine.activefgtvm2]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.res-0.name
  route_table_name       = azurerm_route_table.internal.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport1
}

resource "azurerm_subnet_route_table_association" "internalassociate" {
  depends_on     = [azurerm_route_table.internal]
  subnet_id      = azurerm_subnet.privatesubnet.id
  route_table_id = azurerm_route_table.internal.id
}
