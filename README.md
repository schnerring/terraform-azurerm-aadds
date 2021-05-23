# Azure Active Directory Domain Services (AADDS) Module

Terraform module to deploy Azure Active Directory Domain Services (AADDS).

This module uses version `2021-03-01` of the [`Microsoft.AAD/domainServices`](https://docs.microsoft.com/en-us/azure/templates/microsoft.aad/2021-03-01/domainservices) ARM template. Besides the important notes below, more information regarding setup requirements is available [in the official Azure GitHub](https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices).

## Important Notes

- To support a wide variety of deployment scenarios, a resource group, virtual network and subnet must be pre-provisioned and provided to the module.
  - AADDS requires the chosen subnet to belong to a reserved private IP range: `192.168.0.0/16`, `172.16.0.0/12`, `10.0.0.0/8`
- An active Azure subscription with an Azure Active Directory (AAD) tenant is required
- Only **one AADDS deployment per tenant** is supported.0/8`
- Deployment takes around **40-45 minutes** to complete
