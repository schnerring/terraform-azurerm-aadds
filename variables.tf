variable "resource_group_name" {
  type        = string
  description = "Resource group name that AADDS is deployed to."
}

variable "use_existing_resource_group" {
  type        = bool
  description = "Use pre-provisioned resource group instead of creating one."
  default     = false
}

# Basics

variable "domain_name" {
  type        = string
  description = "Managed domain name."
}

variable "location" {
  type        = string
  description = "Resource location."
}

variable "sku" {
  type        = string
  description = "SKU Type."
  default     = "Enterprise"

  validation {
    condition     = var.sku == "Standard" || var.sku == "Enterprise" || var.sku == "Premium"
    error_message = "The sku value must be Standard, Enterprise or Premium."
  }
}

variable "domain_configuration_type" {
  type        = string
  description = "Domain Configuration Type."
  default     = "FullySynced"

  validation {
    condition     = var.domain_configuration_type == "FullySynced" || var.domain_configuration_type == "ResourceTrusting"
    error_message = "The domain_configuration_type value must be FullySynced or ResourceTrusting."
  }
}

# Networking

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet that AADDS is deployed to."
}

# Administration

variable "administrator_group_members" {
  type        = list(string)
  description = "Object IDs of Users, Groups or Service Principals to be added to AAD DC Administrators group."
  default     = []
}

variable "notify_global_admins" {
  type        = string
  description = "Notify Global Administrators on alerts of warning or critical severity."
  default     = true
}

variable "notify_dc_admins" {
  type        = string
  description = "Notify AAD DC Administrators on alerts of warning or critical severity."
  default     = true
}

variable "notify_additional_email_recipients" {
  type        = list(string)
  description = "List of email addresses notified on alerts of warning or critical severity."
  default     = []
}

# Synchronization

variable "filtered_sync" {
  type        = string
  description = "Enable scoped synchronization."
  default     = false
}

# Security

variable "tls_1_2_only_mode" {
  type        = bool
  description = "Enable TLS 1.2 only mode."
  default     = false
}

variable "ntlm_authentication" {
  type        = bool
  description = "Enable NTLM Authentication."
  default     = true
}

variable "sync_ntlm_passwords" {
  type        = bool
  description = "NTLM Password Synchronization from On-Premises"
  default     = true
}

variable "sync_on_prem_passwords" {
  type        = bool
  description = "Enable Password Synchronization from On-Premises."
  default     = true
}

# TODO: Azure Portal does not (yet?) provide this option
variable "sync_kerberos_passwords" {
  type        = bool
  description = "Kerberos Password Synchronization from On-Premises."
  default     = true
}

variable "kerberos_rc_encryption" {
  type        = bool
  description = "Enable Kerberos RC Encryption."
  default     = true
}

variable "kerberos_armoring" {
  type        = bool
  description = "Enable Kerberos Armoring"
  default     = false
}

# Tags

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
