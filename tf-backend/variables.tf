variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

## S3 bucket settings
variable "name" {
  description = "A name of the S3 bucket"
  type        = string
}

variable "sse_algorithm" {
  description = "S3 bucket default encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "The KMS key ARN for default encryption"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "The bucket key is used to cache the KMS key to reduce the cost of using KMS"
  type        = string
  default     = null
}

# DynamoDB table settings
variable "table_name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
  default     = null # ${var.name}-lock by default
}

variable "hash_key" {
  type        = string
  description = "The attribute to use as the hash (partition) key."
  default     = "LockID"
}

variable "write_capacity" {
  description = "The number of write units for this table."
  type        = number
  default     = 5 # up to 25 WCU for Free Tier
}

variable "read_capacity" {
  description = "The number of read units for this table."
  type        = number
  default     = 5 # up to 25 RCU for Free Tier
}

variable "attribute_name" {
  type        = string
  description = "The name of the attribute"
  default     = "LockID"
}

variable "attribute_key" {
  type        = string
  description = "Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data."
  default     = "S"
}
