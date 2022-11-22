variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "The name of the KMS key"
  type        = string
  default     = "main-key"
}

variable "description" {
  description = "The description of the KMS key"
  type        = string
  default     = null # It's equal to the name by default
}

## optional
variable "accounts" {
  description = "AWS accounts to share the KMS key"
  ## add AWS accounts 012345678901 and 123456789010 to share this KMS
  ## tf apply -var accounts = ["012345678901","123456789010"]
  type        = list(string)
  default     = []
}
