resource "azurerm_linux_virtual_machine" "activefgtvm2" {
  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  disable_password_authentication = false
  location                        = var.location
  name                            = "FGT-Customer02"
  network_interface_ids = [
    azurerm_network_interface.fgtvm2port1.id,
    azurerm_network_interface.fgtvm2port2.id,
    #azurerm_network_interface.fgtvm2port3.id,
    #azurerm_network_interface.fgtvm2port4.id
  ]

  resource_group_name = azurerm_resource_group.res-0.name
  size                = var.size
  tags = {
    Source = "terraform"
  }
  zone = "2"
  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  plan {
    name      = "fortinet_fg-vm"
    product   = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
  }

  source_image_reference {
    offer     = "fortinet_fortigate-vm_v5"
    publisher = "fortinet"
    sku       = "fortinet_fg-vm"
    version   = "7.4.3" //To validate the latest version. "az vm image list --offer fortinet_fortigate-vm_v5 --publisher fortinet --all --query "[].{Sku:sku, Version:version}" --output table"
  }

  custom_data = base64encode(templatefile("${var.bootstrap-active2}", {
    type            = var.license_type,
    license_file    = var.license2,
    port1_ip        = var.fgtvm2port1,
    port1_mask      = var.fgtvm2port1mask,
    port2_ip        = var.fgtvm2port2,
    port2_mask      = var.fgtvm2port2mask,
    defaultgwy      = var.port1gateway,
    trust_gw        = var.port2gateway,
    tenant          = var.tenant_id,
    subscription    = var.subscription_id,
    clientid        = var.client_id,
    clientsecret    = var.client_secret,
    adminsport      = var.adminsport,
    rsg             = azurerm_resource_group.res-0.name,
    clusterip       = azurerm_public_ip.ClusterPublicIP.name,
    routename       = azurerm_route_table.internal.name
  }))

  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_network_interface.fgtvm2port1,
    azurerm_network_interface.fgtvm2port2,
  ]
}


resource "azurerm_virtual_machine_data_disk_attachment" "res-6" {
  caching            = "None"
  #create_option      = "Empty"
  lun                = 0
  managed_disk_id    = azurerm_managed_disk.res-2.id
  virtual_machine_id = azurerm_linux_virtual_machine.activefgtvm2.id
  depends_on = [
    azurerm_resource_group.res-0,
    azurerm_managed_disk.res-2,
    azurerm_linux_virtual_machine.activefgtvm2,
  ]
}

resource "azurerm_managed_disk" "res-2" {
  create_option        = "Empty"
  location             = var.location
  name                 = "FGT-Customer02_disk2"
  resource_group_name  = azurerm_resource_group.res-0.name
  storage_account_type = var.storage_account_type
  disk_size_gb         = var.disk_size_gb

  tags = {
    Source = "terraform"
  }
  zone = "2"
  depends_on = [ azurerm_resource_group.res-0 ]
}