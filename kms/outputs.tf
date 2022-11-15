output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = aws_kms_key.this.arn
}

output "kms_key_alias" {
  description = "The alias of the KMS key"
  value       = aws_kms_alias.this.name
}
