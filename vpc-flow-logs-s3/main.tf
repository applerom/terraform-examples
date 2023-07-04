resource "aws_flow_log" "this" {
  vpc_id                   = var.vpc_id
  log_destination_type     = var.log_destination_type
  log_destination          = var.log_destination_arn
  log_format               = var.log_format
  traffic_type             = var.traffic_type
  max_aggregation_interval = var.max_aggregation_interval # 60 | 600

  destination_options {
    file_format                = var.file_format
    hive_compatible_partitions = var.hive_compatible_partitions
    per_hour_partition         = var.per_hour_partition
  }

  tags = merge(var.tags, var.vpc_flow_log_tags)
}