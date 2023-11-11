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

variable "deletion_window_in_days" {
  description = "Enable KMS key rotation"
  type        = number
  default     = 7
}

variable "enable_key_rotation" {
  description = "Enable KMS key rotation"
  type        = bool
  default     = false
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
