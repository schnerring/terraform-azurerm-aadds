# Azure Active Directory Domain Services (AADDS) Module

Terraform module to deploy Azure Active Directory Domain Services (AADDS).

This module implements the [`Microsoft.AAD/domainServices`](https://docs.microsoft.com/en-us/azure/templates/microsoft.aad/2021-03-01/domainservices) ARM template, version `2021-03-01`. Besides the important notes below, more information regarding setup requirements can be found [on the official Azure GitHub](https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices).

## Important Notes

- An Azure Active Directory (AAD) tenant must exist
- The subscription tenant must not have an existing AADDS deployment, only **one per tenant** is supported
- AADDS requires the chosen subnet to belong to a reserved private IP range:
  - `192.168.0.0/16`
  - `172.16.0.0/12`
  - `10.0.0.0/8`
- Deployment takes around **40-45 minutes** to complete
