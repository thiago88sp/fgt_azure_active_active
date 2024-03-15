# Active/Active High Available FortiGate pair with external and internal Azure Standard Load Balancer

More and more enterprises are turning to Microsoft Azure to extend or replace internal data centers and take advantage of the elasticity of the public cloud. While Azure secures the infrastructure, you are responsible for protecting the resources you put in it. As workloads are being moved from local data centers connectivity and security are key elements to take into account. FortiGate-VM offers a consistent security posture and protects connectivity across public and private clouds, while high-speed VPN connections protect data.

This Terraform template deploys an Active/Active pair combined with the Microsoft Azure Standard Load Balancer both on the external and the internal side. Additionally, Fortinet Fabric Connectors deliver the ability to create dynamic security policies.

# Design

In Microsoft Azure, you can deploy an active/active pair of FortiGate VMs that communicate with each other and the Azure fabric. This FortiGate setup will receive the to be inspected traffic using user defined routing (UDR) and public IPs. You can send all or specific traffic that needs inspection, going to/coming from on-prem networks or public internet by adapting the UDR routing.

This Azure ARM template will automatically deploy a full working environment containing the the following components.

* 2 or more FortiGate firewalls in an active/active deployment
* (Optional) 1 external Azure Standard Load Balancer for communication with internet
* 1 internal Azure Standard Load Balancer to receive all internal traffic and forwarding towards Azure Gateways connecting ExpressRoute or Azure VPNs.
* 1 VNET with an external, internal and a protected subnets
* (Optional) 1 public IP for services and FortiGate management
* User Defined Routes (UDR) for the protected subnets when deployed in a new VNET

![image](https://github.com/thiago88sp/fgt_azure_active_active/assets/54182968/2a43a171-1497-4d8e-bd39-e88be1a36cda)


Example of the following link: https://github.com/fortinet/azure-templates/tree/main/FortiGate/Active-Passive-ELB-ILB


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.externalLB](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb.internalLB](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.res-10](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_backend_address_pool.res-8](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_rule.inbount_nat_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule) | resource |
| [azurerm_lb_probe.externalLB-rule-probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_probe.internalLB-rule-probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.externalLB-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_rule.externalLB-rule-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_rule.internalLB-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.activefgtvm1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.activefgtvm2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.res-1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.res-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.activeport1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.activeport2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.fgtvm2port1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.fgtvm2port2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.res-12](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.res-15](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.res-22](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.res-25](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.res-13](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.res-16](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.res-23](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.res-26](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.res-31](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.res-32](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.res-33](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.ClusterPublicIP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.res-0](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.privatesubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.publicsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.internalassociate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_machine_data_disk_attachment.res-4](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.res-6](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_network.res-40](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activeport1"></a> [activeport1](#input\_activeport1) | NIC 'untrust' private address. | `string` | `"172.18.10.4"` | no |
| <a name="input_activeport1mask"></a> [activeport1mask](#input\_activeport1mask) | NIC netmask 'untrusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_activeport2"></a> [activeport2](#input\_activeport2) | NIC 'trust' private address. | `string` | `"172.18.10.69"` | no |
| <a name="input_activeport2mask"></a> [activeport2mask](#input\_activeport2mask) | NIC netmask 'trusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Fortigate access password | `string` | `"Passw0rd"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Fortigate access user | `string` | `"tsp"` | no |
| <a name="input_adminsport"></a> [adminsport](#input\_adminsport) | Fortigate administration port. | `string` | `"8443"` | no |
| <a name="input_bootstrap-active"></a> [bootstrap-active](#input\_bootstrap-active) | Configuration file for the 'Active' Fortigate. | `string` | `"fgtvma-active.conf"` | no |
| <a name="input_bootstrap-active2"></a> [bootstrap-active2](#input\_bootstrap-active2) | Configuration file for the 'Active2' Fortigate. | `string` | `"fgtvmb-active.conf"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Specifies the size of the managed disk to create in gigabytes | `number` | `"64"` | no |
| <a name="input_fgtvm2port1"></a> [fgtvm2port1](#input\_fgtvm2port1) | NIC 'untrust' private address. | `string` | `"172.18.10.5"` | no |
| <a name="input_fgtvm2port1mask"></a> [fgtvm2port1mask](#input\_fgtvm2port1mask) | NIC netmask 'untrusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_fgtvm2port2"></a> [fgtvm2port2](#input\_fgtvm2port2) | NIC 'trust' private address. | `string` | `"172.18.10.70"` | no |
| <a name="input_fgtvm2port2mask"></a> [fgtvm2port2mask](#input\_fgtvm2port2mask) | NIC netmask 'trusted'. | `string` | `"255.255.255.192"` | no |
| <a name="input_license"></a> [license](#input\_license) | license file for the active1 fgt | `string` | `"license.txt"` | no |
| <a name="input_license2"></a> [license2](#input\_license2) | license file for the active2 fgt | `string` | `"license2.txt"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | License Type to create FortiGate-VM Provide the license type for FortiGate-VM Instances. | `string` | `"byol"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location where resources will be placed | `string` | `"eastus"` | no |
| <a name="input_port1gateway"></a> [port1gateway](#input\_port1gateway) | Public subnet gateway IP. | `string` | `"172.18.10.1"` | no |
| <a name="input_port2gateway"></a> [port2gateway](#input\_port2gateway) | Private subnet gateway IP. | `string` | `"172.18.10.65"` | no |
| <a name="input_privatecidr"></a> [privatecidr](#input\_privatecidr) | Private subnet address space | `string` | `"172.18.10.64/26"` | no |
| <a name="input_publiccidr"></a> [publiccidr](#input\_publiccidr) | Public subnet address space | `string` | `"172.18.10.0/26"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | `"rsg-tsp-act-act"` | no |
| <a name="input_size"></a> [size](#input\_size) | Virtual machine SKU. | `string` | `"Standard_DS3_v2"` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | Storage type chosen for the managed disk. | `string` | `"Premium_LRS"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure configuration | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_vnetcidr"></a> [vnetcidr](#input\_vnetcidr) | VNET address space | `string` | `"172.18.10.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_FrontendIP-ELB"></a> [FrontendIP-ELB](#output\_FrontendIP-ELB) | External Load Balancer public IP. |
| <a name="output_FrontendIP-ILB"></a> [FrontendIP-ILB](#output\_FrontendIP-ILB) | Internal Load Balancer private IP. |
| <a name="output_Password"></a> [Password](#output\_Password) | Fortigate access password |
| <a name="output_ResourceGroup"></a> [ResourceGroup](#output\_ResourceGroup) | Resource Group where the FortiGates are placed |
| <a name="output_Username"></a> [Username](#output\_Username) | Fortigate access user |