variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "A name of the S3 bucket"
  type        = string
}

## optional
variable "shared_path" {
  description = "The shared path in the S3 bucket"
  type        = string
  default     = "shared/*"
}

variable "accounts" {
  description = "AWS accounts to share the S3 share"
  type        = list(string)
  default     = []
}

variable "sse_algorithm" {
  description = "S3 bucket default encryption algorithm - AES256 or 'aws:kms'"
  type        = string
  default     = "AES256" ## Enable S3-SSE encryption by default - it's free and suitable for public access
}

variable "kms_key_arn" {
  description = "The KMS key ARN for default encryption"
  type        = string
  default     = null ## must be 'null' for AES256
}

variable "bucket_key_enabled" {
  description = "The bucket key is used to cache the KMS key to reduce the cost of using KMS"
  type        = string
  default     = null ## must be 'null' for AES256
}
