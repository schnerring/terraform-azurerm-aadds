# Azure Active Directory Domain Services (AADDS) Module

Terraform module for deploying Azure Active Directory Domain Services (AADDS), providing the same configuration options as the AADDS configuration wizard in the Azure Portal.

It uses version `2021-03-01` of the [`Microsoft.AAD/domainServices`](https://docs.microsoft.com/en-us/azure/templates/microsoft.aad/2021-03-01/domainservices) ARM template to deploy AADDS. Besides the notes below, more information regarding setup requirements is available [in the official Azure GitHub](https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices).

[You can read about the thoughts going into the implementation of this module on my blog](https://schnerring.net/posts/set-up-azure-active-directory-domain-services-aadds-with-terraform/).

## Important Notes

- To support a wide variety of deployment scenarios, a resource group, virtual network, and subnet must be pre-provisioned and provided to the module.
  - AADDS requires the chosen subnet to belong to a reserved private IP range: `192.168.0.0/16`, `172.16.0.0/12`, `10.0.0.0/8`
- An active Azure subscription with an Azure Active Directory (AAD) tenant is required
- Only **one AADDS deployment per tenant** is supported.
- Deployment takes around **40-45 minutes** to complete

## Minimal Example

```hcl
resource "azurerm_resource_group" "aadds" {
  name     = "aadds-rg"
  location = "Switzerland North"
}

resource "azurerm_virtual_network" "aadds" {
  name                = "aadds-vnet"
  resource_group_name = azurerm_resource_group.aadds.name
  location            = "Switzerland North"

  address_space = ["10.0.0.0/16"]

  # AADDS DCs
  dns_servers = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "aadds" {
  name                 = "aadds-snet"
  resource_group_name  = azurerm_resource_group.aadds.name
  virtual_network_name = azurerm_virtual_network.aadds.name

  address_prefixes = ["10.0.0.0/24"]
}

module "aadds" {
  source  = "schnerring/aadds/azurerm"
  version = "0.1.1"

  resource_group_name = azurerm_resource_group.aadds.name
  location            = "Switzerland North"
  domain_name         = "aadds.schnerring.net"
  subnet_id           = azurerm_subnet.aadds.id
}
```
