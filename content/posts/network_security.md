+++
title = "Automating Hub & Spoke Secure Azure Networks with Terraform (IaC) & Azure Firewalls"
date = 2025-09-12
author = "Francis Adeboye"
draft = false
tags = ["Firewall", "Terraform", "IaC", "Hub&Spoke", "Azure", "Vnet", "NSG", "ASG"]
categories = ["Docs"]
+++

<img width="1000" height="420" alt="image" src="https://github.com/user-attachments/assets/6dfb710e-de8c-4028-b30e-b29181dd4a4c" />


## Introduction

Imagine your business’s digital assets—all your **customer data, company secrets, and applications**—are stored inside a high-value property. Without security guards or locks on the doors, this property is an open invitation for **burglars (Vulnerabilities)**. In the same way, an insecure cloud network is a prime target for cyber threats.

**Cloud network security** provides those essential guards and locks **(Virtual Network, Security Groups, Firewalls & Encryption)**, protecting your most valuable digital assets from a growing number of attackers.

However, managing security in a vast and constantly changing cloud environment is nearly impossible to do manually. This is where automation becomes your most critical tool. By **integrating smart, automated systems**, you can ensure every door is locked and every alarm is active, making your **digital property secure and resilient** in real time.

## Architecture Overview

![Architectural Overview](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jntezc8737rr4h6hybhi.png)

### Hub-Spoke Network Concept
Your network uses a Hub-Spoke model, which is a highly effective way to manage a cloud network. The Hub is your central security and connectivity point, where an Azure Firewall inspects all traffic. The Spokes are isolated networks that host your applications. This design provides centralized security, simplifies routing, and makes your network easy to scale.

### Network Components
- **Hub VNet**: This is where the Azure Firewall is deployed. It's the central checkpoint for all traffic.

- **App (Spoke) VNet**: This is where your applications are deployed. The frontend is secured using an Application Security Group (ASG), while the backend uses a Network Security Group (NSG) for granular control.

- **DNS**: A Private DNS Zone is used to resolve internal names, ensuring your applications can communicate with each other securely using private records.

- **Route Tables**: These are configured with User-Defined Routes (UDRs) to force all traffic from the spokes to pass through the hub's firewall.

### Traffic Flow

- **Inbound Traffic**: Traffic from the internet goes directly to the Hub Firewall, which then forwards it to the correct application in the spoke VNet. The ASG on the frontend ensures only allowed traffic reaches the web servers.

- **Outbound Traffic**: Traffic from an application in the spoke VNet is sent to the Hub Firewall for inspection before it can reach the internet.

- **DNS Flow**: DNS queries are handled internally via the Private DNS Zone, with the hub firewall forwarding the requests.

## Deploying Infrastructure as Code (IaC) with Terraform

Terraform is an essential tool for implementing this architecture because it allows an organization to define its entire **infrastructure as code (IaC)**. This approach offers several key benefits: it ensures **repeatable, immutable & consistent deployments, makes infrastructure version-controlled (just like application code)** to track changes, and enables fully automated deployments.

### Prerequisites 
- Azure Account & Azure Subscription
- Azure CLI
- App Role that allows Terraform Deployment
- Terraform Installed
- [Azure Terraform Visual Studio code extension](https://learn.microsoft.com/en-us/azure/developer/terraform/configure-vs-code-extension-for-terraform?tabs=azure-cli)
- Remote Backend ([Hashicorp Cloud with CLI workflow](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up) or [Azure Storage Account](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)): For this lab, I'll be using a HashiCorp Terraform Cloud account. This approach provides a managed, secure, and collaborative environment for storing the Terraform state file, which is often easier to set up and manage than a self-hosted Azure Storage Account for state management.

To make the code flexible, it is best to use variables for key settings like **IP ranges, location, and resource group names**. This makes it easy to deploy the same architecture in different environments (e.g., development, staging, production) with a single command.

A crucial best practice is to use **remote state management.** By storing the Terraform state file in a remote backend **(like HashiCorp Terraform Cloud or an Azure Storage Account)**, it **prevents state conflicts**, **enables collaboration among team members**, and **ensures the state is backed up and secure**.

### Terraform File Structure

Terraform project directory for this architecture would be organized & created as follows:

- `main.tf`: This core file would declare the `azurerm` provider and the Terraform remote backend configuration for state management. This ensures state is stored securely and enables team collaboration.
```
#############################################
# Provider & HCP Remote Backend Configuration
#############################################

terraform {
  cloud {
    organization = "your-organization-name"
    workspaces {
      name = "secure-network-workload"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}
```

- `deployments.tf`: This is the primary file that holds all resources blocks for the deployment. This is where resource group, virtual networks, subnets, firewalls, security groups, virtual machines and other network components would be declared.
```
###################################
# Azure Resources for Deployment
###################################

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project_name}-${var.prefix}-RG"
  location = var.location
  tags     = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}
```

- `variables.tf`: This file contains all the input variables for the configuration. This allows for easy customization without changing the main code.
```
#####################################
# Variables for Deployment
#####################################
variable "prefix" {
  type    = string
}

variable "project_name" {
  type = string
}

variable "owner_name" {
  type = string

}

variable "managed_by" {
  type = string

}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
```
- `outputs.tf`: This file specifies the values that will be outputted after a successful deployment, such as the public/private IPs of the firewall or the IDs of the created subnets.

```
#####################################
# Deployment Outputs
#####################################
output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.resource_group.name
}
```
- `terraform.tfvars`: This file holds the actual values for the variables declared in variables.tf.
```
####################################################################
# Terraform variables for Network Secure Workload Project Deployment
####################################################################

location     = "UK South"
project_name = "Hub-Spoke-Network"
environment  = "Development"
owner_name   = "Francis Adeboye"
managed_by   = "Terraform"
prefix      = "nsw-dev"

tags = {
  Owner       = "Francis Adeboye"
  Project     = "Hub-Spoke-Network"
  Contact     = "your-email-address"
  Environment = "Development"
  ManagedBy   = "Terraform"
}
```

![file-structure](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nrz5h2hmyurf4qpto40y.png)

### Deployment Flow (Hands-on Lab)
**Initializing Terraform** - Before deploying any infrastructure, the first step is to initialize the Terraform project. This is done with the `terraform init` command. Other commands will be used subsequently during this hands-on where applicable.

**`terraform init`**: This command initializes the working directory, downloads the necessary provider plugins, and sets up the remote backend for state management.

**`terraform fmt`**: This command formats the configuration files to ensure consistent style and readability.

**`terraform validate`**: This command validates the syntax of the configuration, checking for errors before deployment.

**`terraform plan`**: This command creates an execution plan, showing what resources will be created, modified, or destroyed, and is a crucial step for reviewing changes before deployment.

**`terraform apply`**: This command applies the changes defined in the plan to the cloud provider, creating the infrastructure.

**`terraform destroy`**: This command destroys all the resources managed by the configuration, used for cleaning up the environment.

![init,fmt,validate](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/f49gnxwqro7h7st11896.png)
![plan&apply](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tz20gugryezi15povs0g.png)

### Create and configure virtual networks
- Create a **Resource Group**
```
###################################
# Azure Resource Group
###################################

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project_name}-${var.prefix}-RG"
  location = var.location
  tags     = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}
```
![planapprove](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ig65pe07d2xxle59qvss.png)
![resource_group](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9rjkuy6z5l6jsq3p8eln.png)

- Create **Spoke (App)** virtual network with Subnets **(Front & Back End)**

```
###################################
# Resource Group Data Source
###################################

data "azurerm_resource_group" "resource_group" {
  name     = "${var.project_name}-${var.prefix}-RG"
}


###################################
# Spoke App Virtual Network
###################################
resource "azurerm_virtual_network" "spoke_app_vnet" {
  name                = var.spoke_app_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.spoke_app_address_space

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}

# Subnets for Spoke App VNet
resource "azurerm_subnet" "front_end_app_subnet" {
  name                 = "front-end-app-subnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.spoke_app_vnet.name
  address_prefixes     = [var.front-end-app]
}

resource "azurerm_subnet" "back_end_app_subnet" {
  name                 = "back-end-app-subnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.spoke_app_vnet.name
  address_prefixes     = [var.back-end-app]
}

```
![Spoke-App-Vnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/yckqjmjeszr06g5d5rxf.png)

- Create **Hub** Virtual network with Subnet **(Azure Firewall)**

```
###################################
# Hub Vnet for Azure Firewall
###################################
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.hub_address_space

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}

# Subnet for Azure Firewall

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.firewall-subnet]
}
```
![hubfirewall](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/prbtzxybvjznrivtss3e.png)

![Hub-Vnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c7yx6xbi3pjc5ji0iwk3.png)

- Configure **Vnet peering** between Hub & Spoke Virtual Network

```
####################################
# Vnet Peering between Hub and Spoke
####################################

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub-vnet"
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.spoke_app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = "true"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke-vnet"
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_app_vnet.id
  allow_virtual_network_access = "true"
}
```
![Hub-Spoke](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/66x4wadnfgno5hpnmwpy.png)

![Spoke-Hub](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3x45llvyc2sk94o2o7fu.png)

### Create and configure Virtual Machines & network security groups (ASG & NSG)

- Create **2 Virtual Machines** (Linux Ubuntu Server)

```

#################################################################################
# Virtual Machine Deployment
#################################################################################
# Public IP Addresses
resource "azurerm_public_ip" "vm1_public_ip" {
  name                = "VM1-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                = "Standard"
}

resource "azurerm_public_ip" "vm2_public_ip" {
  name                = "VM2-ip" 
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "vm1_nic" {
  name                = "VM1-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.front_end_app_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm1_public_ip.id
  }
}

resource "azurerm_network_interface" "vm2_nic" {
  name                = "VM2-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.back_end_app_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm2_public_ip.id
  }
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "VM1"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb        = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = false
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "VM2"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm2_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb        = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = false
}

```

![VM](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tpc7u8yr3p8qfw31ijx0.png)

- Create **Application Security Group (ASG)** & Attach to VM-1 (NIC)

```
###########################################################
# Application Security Group (front-end) attached to VM1 NIC
###########################################################
resource "azurerm_application_security_group" "app_front_end_asg" {
  name                = "app-front-end-asg"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}

# Attach ASG to VM1 NIC

resource "azurerm_network_interface_application_security_group_association" "vm1_nic_asg_assoc" {
  network_interface_id          = azurerm_network_interface.vm1_nic.id
  application_security_group_id = azurerm_application_security_group.app_front_end_asg.id
}
```
![ASG](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pzjdpmggixsn1xakwd0y.png)

- Create **Network Security Group (NSG)** & Associate with Backend Subnet

```
###########################################################
# Network Security Group (back-end) attached to back-end subnet
###########################################################
resource "azurerm_network_security_group" "back_end_nsg" {
  name                = "app-back-end-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}
# Attach NSG to back-end subnet
resource "azurerm_subnet_network_security_group_association" "back_end_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.back_end_app_subnet.id
  network_security_group_id = azurerm_network_security_group.back_end_nsg.id
}
```
![nsg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/sdufpyi7n67yw2gt9f08.png)

- Create **Network Security Group** inbound rules filter traffic to ASG on Port 22 (ASG)

```
#####################################################################################################################
# NSG Rule to filter inbound/outbound traffic from anywhere on port 22 (SSH) to Application Security Group (front-end)
#####################################################################################################################
resource "azurerm_network_security_rule" "allow_ssh_inbound" {
  name                                       = "Allow-ssh-Inbound"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  source_address_prefix                      = "*"
  destination_port_range                     = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.app_front_end_asg.id]
  resource_group_name                        = azurerm_resource_group.resource_group.name
  network_security_group_name                = azurerm_network_security_group.back_end_nsg.name
}
```
![inbound-nsg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1kbmdl6h4mbpc2ex9hp2.png)

### Create and configure Azure Firewall
- Create Azure Firewall Subnet in Spoke (App) Vnet

```
###########################################################
# Azure Firewall Subnet (Spoke Vnet)
###########################################################
resource "azurerm_subnet" "spoke_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.spoke_app_vnet.name
  address_prefixes     = [var.spoke-firewall-subnet]
}
```
![fw-subnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1vijdc0f2w94ihgzot8k.png)

- Configure Azure Firewall & firewall policy

```
######################################################################
# Standard Firewall (Spoke App Vnet), with Firewall Policy & Public IP
######################################################################
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku                 = "Standard"

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}

resource "azurerm_firewall" "app_firewall" {
  name                = "firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = azurerm_subnet.spoke_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  tags = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}
```
![firewall-fwpolicy](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7bqcmrlr9l11jqgpvmbb.png)


- Update firewall policy Collection group with application & network rule collection

```
###########################################################
# Update Firewall Policy with Collection Group (App & Network Rules)
###########################################################

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rule_collection_group" {
  name               = "fw-policy-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 200

  application_rule_collection {
    name     = "app-vnet-fw-rule-collection"
    priority = 200
    action   = "Allow"
    rule {
      name              = "AllowAzurePipelines"
      source_addresses  = ["10.20.0.0/23"]
      destination_fqdns = ["dev.azure.com", "azure.microsoft.com"]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "app-vnet-fw-nrc-dns"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "AllowDns"
      protocols             = ["UDP"]
      source_addresses      = ["10.20.0.0/23"]
      destination_ports     = ["53"]
      destination_addresses = ["1.1.1.1", "1.0.0.1"]
    }
  }
}
```
![rule collection](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pdr4oi9fzit9up0kss7l.png)

### Configure network routing to Spoke (App) Vnet Firewall

- Create and configure a route table.

```
#####################################
# Spoke Vnet Firewall Route Table
#####################################
resource "azurerm_route_table" "spoke_firewall_route_table" {
  name                = "spoke-vnet-firewall-rt"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = coalesce(var.tags, { Project = var.project_name, Environment = var.environment, Owner = var.owner_name, ManagedBy = var.managed_by })
}
```

![route-table](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/efeu4k7zroqbfgmr7770.png)


- Associate Route Table to Front End & Back End Subnet

```
##################################################################
# Associate Route Table to Spoke App Subnets (front-end & back-end)
##################################################################
resource "azurerm_subnet_route_table_association" "front_end_app_subnet" {
  subnet_id      = azurerm_subnet.front_end_app_subnet.id
  route_table_id = azurerm_route_table.spoke_firewall_route_table.id
}

resource "azurerm_subnet_route_table_association" "back_end_app_subnet" {
  subnet_id      = azurerm_subnet.back_end_app_subnet.id
  route_table_id = azurerm_route_table.spoke_firewall_route_table.id
}
```
![route](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i8tr5c9p9d46aovd5i1d.png)

- Create Route to Route Outbound traffic via Network Virtual Appliance (NVA) Firewall private IP address

```
##################################################################
# Routes Outgoing Traffic via NVA Firewall using Firewall Private IP
##################################################################
resource "azurerm_route" "outbound_firewall_route" {
  name                   = "outbound-firewall-route"
  route_table_name       = azurerm_route_table.spoke_firewall_route_table.name
  resource_group_name    = azurerm_resource_group.resource_group.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.app_firewall.ip_configuration[0].private_ip_address
}
```
![rta](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pbb6m92alm8bktq4fhyu.png)


### Create DNS zones and configure DNS settings
- Create and configure a private DNS zone.

```
###################################################
# Private DNS Zone private.contoso.com
###################################################
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "private.contoso.com"
  resource_group_name = azurerm_resource_group.resource_group.name
}
```

![private-dns](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n7ndh12d5z6bmgcb2v5w.png)

- Configure Virtual Network Link for Private DNS zone

```
##############################################
# Private DNS Zone Vnet Link to Spoke App Vnet
###############################################
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  name                  = "dns-zone-vnet-link"
  resource_group_name   = azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.spoke_app_vnet.id
  registration_enabled  = true
}
```
![virtual-link](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ygkxt7mcvmeokjrxgiis.png)


- Create and configure DNS (A)records mapping backend (VM2)

```
##########################################################
# Private DNS A Record for Backend VM in Private DNS Zone
##########################################################
resource "azurerm_private_dns_a_record" "backend_vm_dns_record" {
  name                = "backend-vm"
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.resource_group.name
  ttl                 = 1
  records             = [azurerm_network_interface.vm2_nic.private_ip_address]
}
```
![rta2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b01xygxtbjh1he6jetm6.png)

### Cleaning up resources 

When you’re done testing and validating the deployment, it’s a good practice to tear down all the infrastructure you created. This avoids unnecessary costs and keeps your Azure subscription tidy.

With Terraform, cleanup is simple. Just run:

`terraform destroy --auto-approve`

This command:

- Destroys all resources defined in your Terraform state.

- Uses `--auto-approve` to skip the interactive confirmation step.

- Ensures your Azure subscription is returned to a clean state.

Here’s an example of Terraform tearing down the resources in my remote backend workspace:

![terraform workspace](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/m74ks66mx0bbegk7yw0b.png)

![terraform-destroy](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4pjyokmisu03m9rdgaao.png)

### Resources

[Terraform AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

[Terraform Deployment Files](https://gist.github.com/adeboyefrancis/a46b1ad08871bca7483240c45c819bfc)


## Conclusion
Using **Terraform and Infrastructure as Code**, we've built a **secure hub-and-spoke network in Azure that’s automated, consistent, and easy to scale**. This setup helps **reduce manual errors and makes it simple to manage environments**.

One key lesson: it’s important to carefully choose where firewalls sit — whether centralized or in each spoke — and to set up DNS correctly to avoid routing issues. With smart design choices, you can create cloud networks that are both secure and flexible, ready to grow with your needs.
