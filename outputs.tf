output "admin_group_object_id" {
  description = "The object ID of the AAD DC Administrators group."
  value       = azuread_group.aadds.object_id
}
