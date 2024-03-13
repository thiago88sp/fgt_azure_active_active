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

![image](https://github.com/thiago88sp/fgt_azure_active_passive/assets/54182968/fed52167-7ccf-49d6-a847-3faea3118d3d)



Example of the following link: https://github.com/fortinet/azure-templates/tree/main/FortiGate/Active-Passive-ELB-ILB
