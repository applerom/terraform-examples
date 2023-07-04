variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "log_destination_type" {
  description = "The format for the flow log."
  type        = string
  default     = "s3" # s3 | cloud-watch-logs
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = ""
}

variable "file_format" {
  description = "The format for the flow log."
  type        = string
  default     = "parquet" # plain-text | parquet
}

variable "max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record."
  type        = number
  default     = 600 # 60 | 600
}

variable "traffic_type" {
  description = "The type of traffic to capture."
  type        = string
  default     = "ALL" # ACCEPT | REJECT | ALL
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
