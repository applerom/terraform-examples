variable "region" {
  description = "AWS Region"
  type        = string
}

variable "name" {
  description = "The name of the KMS key"
  type        = string
}

variable "description" {
  description = "The description of the KMS key"
  type        = string
  default     = null # It's equal to the name by default
}

## optional
variable "accounts" {
  description = "AWS accounts to share the KMS key"
  type        = list(string)
  default     = []
}
