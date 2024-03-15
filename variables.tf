// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "resource_group_name" {
  type        = string
  default     = "rsg-tsp-act-act"
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location where resources will be placed"
}

###########################################################################################
#                                 Network variables                                       #
###########################################################################################

// Vnets and subnets variables

variable "vnetcidr" {
  default = "172.18.10.0/24"
  description = "VNET address space"
}

variable "publiccidr" {
  default = "172.18.10.0/26"
  description = "Public subnet address space"
}

variable "privatecidr" {
  default = "172.18.10.64/26"
  description = "Private subnet address space"
}


variable "port1gateway" {
  default = "172.18.10.1"
  description = "Public subnet gateway IP."
}

variable "port2gateway" {
  default = "172.18.10.65"
  description = "Private subnet gateway IP."
}

variable "adminsport" {
  type    = string
  default = "8443"
  description = "Fortigate administration port."
}

// NIC - Active VM

variable "activeport1" {
  default = "172.18.10.4"
  description = "NIC 'untrust' private address."

}

variable "activeport1mask" {
  default = "255.255.255.192"
  description = "NIC netmask 'untrusted'."
}

variable "activeport2" {
  default = "172.18.10.69"
  description = "NIC 'trust' private address."
}

variable "activeport2mask" {
  default = "255.255.255.192"
  description = "NIC netmask 'trusted'."
}


// NIC - Passive VM

variable "fgtvm2port1" {
  default = "172.18.10.5"
  description = "NIC 'untrust' private address."
}

variable "fgtvm2port1mask" {
  default = "255.255.255.192"
  description = "NIC netmask 'untrusted'."
}

variable "fgtvm2port2" {
  default = "172.18.10.70"
  description = "NIC 'trust' private address."
}

variable "fgtvm2port2mask" {
  default = "255.255.255.192"
  description = "NIC netmask 'trusted'."
}

###########################################################################################
#                                 Virtual machine variables                               #
###########################################################################################

//  For HA, choose instance size that support 4 nics at least
//  Check : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes

variable "admin_username" {
  type        = string
  default     = "tsp"
  description = "Fortigate access user"
}

variable "admin_password" {
  type        = string
  default     = "Passw0rd"
  description = "Fortigate access password"
}

// VM Settings

variable "storage_account_type" {
  type    = string
  default = "Premium_LRS"
  description = "Storage type chosen for the managed disk."
}

variable "size" {
  type    = string
  default = "Standard_DS3_v2"
  description = "Virtual machine SKU."
}

variable "disk_size_gb" {
  type        = number
  default     = "64" #default is 30 according to Fortinet Documentation
  description = "Specifies the size of the managed disk to create in gigabytes"
}

// Bootstrap

variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "fgtvma-active.conf"
  description = "Configuration file for the 'Active' Fortigate."
}

variable "bootstrap-active2" {
  // Change to your own path
  type    = string
  default = "fgtvmb-active.conf"
  description = "Configuration file for the 'Active2' Fortigate."
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances.
variable "license_type" {
  default = "byol"
  description = "License Type to create FortiGate-VM Provide the license type for FortiGate-VM Instances."
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
  description = "license file for the active1 fgt"
}

variable "license2" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license2.txt"
  description = "license file for the active2 fgt"
}
