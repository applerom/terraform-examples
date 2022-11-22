## AWS provider
provider "aws" {
  region  = local.region

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

## main configuration
locals {
  region     = "us-east-1"
  vpc_name   = "Vpc4"
  vpc_prefix = "10.40"
  public_suffix  = "Public"
  private_suffix = "Private App"
  intra_suffix   = "Intra DB"
  public_name  = "${local.vpc_name} ${local.public_suffix}"
  private_name = "${local.vpc_name} ${local.private_suffix}"
  intra_name   = "${local.vpc_name} ${local.intra_suffix}"
}

## get availability zones except very old in N.Virginia to avoid problems with EKS etc
data "aws_availability_zones" "azs" {
  state = "available"
  exclude_zone_ids = ["use1-az3"] # exclude the old zone without modern instances in the us-east-1
}

## VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = "${local.vpc_prefix}.0.0/16"

  azs = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1], data.aws_availability_zones.azs.names[2]]
  public_subnets  = ["${local.vpc_prefix}.11.0/24", "${local.vpc_prefix}.12.0/24", "${local.vpc_prefix}.13.0/24"]
  private_subnets = ["${local.vpc_prefix}.21.0/24", "${local.vpc_prefix}.22.0/24", "${local.vpc_prefix}.23.0/24"]
  intra_subnets   = ["${local.vpc_prefix}.31.0/24", "${local.vpc_prefix}.32.0/24", "${local.vpc_prefix}.33.0/24"]
 
  public_subnet_names  = ["${local.public_name} A",  "${local.public_name} B",  "${local.public_name} C"]
  private_subnet_names = ["${local.private_name} A", "${local.private_name} B", "${local.private_name} C"]
  intra_subnet_names   = ["${local.intra_name} A",   "${local.intra_name} B",   "${local.intra_name} C"]
 
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  ## for thouse who prefer the default suffix instead of full tags (and uses only lowercase letters and dashes)
  #public_subnet_suffix  = lower(replace(local.public_name, " ", "-"))
  #private_subnet_suffix = lower(replace(local.private_name, " ", "-"))
  #intra_subnet_suffix   = lower(replace(local.intra_name, " ", "-"))

  enable_ipv6 = true
  assign_ipv6_address_on_creation = true

  public_subnet_ipv6_prefixes  = [17, 18, 19] # 11, 12, 13 in hex
  private_subnet_ipv6_prefixes = [33, 34, 35] # 21, 22, 23 in hex
  intra_subnet_ipv6_prefixes   = [49, 50, 51] # 31, 32, 33 in hex

  public_route_table_tags = {
    Name = local.public_name
  }
  private_route_table_tags = {
    Name = local.private_name
  }
  intra_route_table_tags = {
    Name = local.intra_name
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

}

locals {
  ## vpc_flow_logs_s3_bucket_name should be unique
  vpc_flow_logs_s3_bucket_name = "${lower(local.vpc_name)}-flow-logs-${data.aws_caller_identity.current.account_id}"
}

## get current AWS account ID - data.aws_caller_identity.current.account_id
data "aws_caller_identity" "current" {}

# S3 bucket for VPC flow logs
module "vpc_flow_logs_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = local.vpc_flow_logs_s3_bucket_name
  policy        = data.aws_iam_policy_document.vpc_flow_logs.json

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule = [
    {
      id      = "vpc-flow-logs"
      enabled = true

      filter = {
        prefix = "/"
      }

      expiration = {
        days = 90
      }
    }
  ]
}

## S3 bucket policy for VPC flow logs
data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::${local.vpc_flow_logs_s3_bucket_name}/AWSLogs/*"]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${local.vpc_flow_logs_s3_bucket_name}"]
  }
}
