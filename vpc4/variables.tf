variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "Vpc4"
}

variable "az_count" {
  description = "The count of the availability zones"
  type        = number
  default     = 3
}

variable "cidr_block" {
  description = "CIDR block for IPv4"
  type        = string
  default     = "10.40.0.0/16"
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
