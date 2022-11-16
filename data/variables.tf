variable "region" {
  description = "AWS Region"
  type        = string
}

variable "accounts" {
  description = "AWS accounts"
  type        = map(string)
}
