output "accounts" {
  description = "AWS accounts"
  value       = var.accounts
}

output "organization_id" {
  description = "AWS Organization ID"
  value       = data.external.organization.result["id"]
}
