variable "name" {
  description = "VPC name"
  type        = string
  default     = "Vpc4"
}

variable "vpc_prefix" {
  description = "VPC prefix"
  type        = string
  default     = "10.40"
}

variable "az_count" {
  description = "The count of the availability zones"
  type        = number
  default     = 3
}

variable "public_suffix" {
  description = "Suffix block for public subnets"
  type        = string
  default     = "Public"
}

variable "private_suffix" {
  description = "Suffix block for private subnets"
  type        = string
  default     = "Private App"
}

variable "intra_suffix" {
  description = "Suffix block for intra subnets"
  type        = string
  default     = "Intra DB"
}
