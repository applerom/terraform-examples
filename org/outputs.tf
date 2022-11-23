output "accounts" {
  description = "AWS accounts"
  value       = var.accounts
}

output "devops_id" {
  description = "Devops AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "root_id" {
  description = "Management (root, master) AWS account ID"
  value       = data.external.organization.result["root"]
}

output "organization_id" {
  description = "AWS Organization ID"
  value       = data.external.organization.result["id"]
}
