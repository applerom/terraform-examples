variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "accounts" {
  description = "AWS accounts"
  type        = map(string)
  default     = {}
}
