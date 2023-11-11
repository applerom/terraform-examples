variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "A name of the IAM role"
  type        = string
  default     = "AWSDevOpsRole"
}

variable "accounts" {
  description = "AWS accounts to trust this IAM role (from which you can switch to it)"
  type        = list(string)
  default     = []
}
