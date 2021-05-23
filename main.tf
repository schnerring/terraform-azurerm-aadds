terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source  = "azurerm"
      version = ">= 2.60.0"
    }

    azuread = {
      source  = "azuread"
      version = ">= 1.5.0"
    }
  }
}

# Resource Group

# Register the Azure Active Directory Application Service Principal
# https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices#3-register-the-azure-active-directory-application-service-principal
resource "azuread_service_principal" "aadds" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36"
  tags           = ["AADDS"]
}

# Configure Administrative Group
# https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices#4-configure-administrative-group
resource "azuread_group" "aadds" {
  display_name = "AAD DC Administrators"
  description  = "Delegated group to administer Azure AD Domain Services"
  members      = var.administrator_group_members
}

# Register Microsoft.AAD resource provider
# https://github.com/Azure/azure-quickstart-templates/tree/master/101-AAD-DomainServices#5-register-resource-provider
resource "azurerm_resource_provider_registration" "aadds" {
  name = "Microsoft.AAD"
}

# See https://docs.microsoft.com/en-us/azure/active-directory-domain-services/alert-nsg#inbound-security-rules
resource "azurerm_network_security_group" "aadds" {
  name                = "aadds-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowRD"
    access                     = "Allow"
    priority                   = 201
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "CorpNetSaw"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3389"
  }

  security_rule {
    name                       = "AllowPSRemoting"
    access                     = "Allow"
    priority                   = 301
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureActiveDirectoryDomainServices"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "5986"
  }

  depends_on = [azurerm_resource_group.aadds]
}

resource "azurerm_subnet_network_security_group_association" "aadds" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.aadds.id
}

resource "azurerm_resource_group_template_deployment" "aadds" {
  name                = "aadds-deploy"
  resource_group_name = var.resource_group_name
  tags                = var.tags

  deployment_mode = "Incremental"

  template_content = templatefile(
    "${path.module}/aadds-arm-template.tpl.json",
    {
      # Basics
      "domainName"              = var.domain_name
      "location"                = var.location
      "sku"                     = var.sku
      "domainConfigurationType" = var.domain_configuration_type

      # Networking
      "subnetId" = var.subnet_id

      # Administration
      "notifyGlobalAdmins"   = var.notify_global_admins ? "Enabled" : "Disabled"
      "notifyDcAdmins"       = var.notify_dc_admins ? "Enabled" : "Disabled"
      "additionalRecipients" = jsonencode(var.notify_additional_email_recipients)

      # Synchronization
      "filteredSync" = var.filtered_sync ? "Enabled" : "Disabled"

      # Security
      "tlsV1"                 = !var.tls_1_2_only_mode ? "Enabled" : "Disabled"
      "ntlmV1"                = var.ntlm_authentication ? "Enabled" : "Disabled"
      "syncNtlmPasswords"     = var.sync_ntlm_passwords ? "Enabled" : "Disabled"
      "syncOnPremPasswords"   = var.sync_on_prem_passwords ? "Enabled" : "Disabled"
      "kerberosRc4Encryption" = var.kerberos_rc_encryption ? "Enabled" : "Disabled"
      "syncKerberosPasswords" = var.sync_kerberos_passwords ? "Enabled" : "Disabled"
      "kerberosArmoring"      = var.kerberos_armoring ? "Enabled" : "Disabled"

      # Tags
      "tags" = jsonencode(var.tags)
    }
  )

  depends_on = [azurerm_resource_provider_registration.aadds]
}
