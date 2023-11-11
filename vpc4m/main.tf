## Get availability zones, except very old ones in N.Virginia to avoid problems with EKS, etc.
data "aws_availability_zones" "azs" {
  state            = "available"
  #exclude_zone_ids = ["use1-az3"] ## use1-az3 - does not suport M5 instances and newer
  exclude_zone_ids = ["use1-az1", "use1-az2", "use1-az3"] ## use1-az1/use1-az2 - do not suport Graviton 3E and newer
}

## subnet names
locals {
  public_name  = "${var.name} ${var.public_suffix}"
  private_name = "${var.name} ${var.private_suffix}"
  intra_name   = "${var.name} ${var.intra_suffix}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                          = var.name
  azs                           = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1], data.aws_availability_zones.azs.names[2]]
  cidr                          = "${var.vpc_prefix}.0.0/16"
  manage_default_vpc            = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  public_subnets  = ["${var.vpc_prefix}.11.0/24", "${var.vpc_prefix}.12.0/24", "${var.vpc_prefix}.13.0/24"]
  private_subnets = ["${var.vpc_prefix}.21.0/24", "${var.vpc_prefix}.22.0/24", "${var.vpc_prefix}.23.0/24"]
  intra_subnets   = ["${var.vpc_prefix}.31.0/24", "${var.vpc_prefix}.32.0/24", "${var.vpc_prefix}.33.0/24"]

  public_subnet_names  = ["${local.public_name} A", "${local.public_name} B", "${local.public_name} C"]
  private_subnet_names = ["${local.private_name} A", "${local.private_name} B", "${local.private_name} C"]
  intra_subnet_names   = ["${local.intra_name} A", "${local.intra_name} B", "${local.intra_name} C"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true ## [EC2.10] Amazon EC2 should be configured to use VPC endpoints that are created for the Amazon EC2 service
  enable_dns_support   = true ## To use the private DNS option, the following attributes of your VPC must be set to true: enableDnsHostnames, enableDnsSupport

  ## AWS Foundational Security Best Practices v1.0.0 - EC2.15
  map_public_ip_on_launch = false ## EC2 subnets should not automatically assign public IP addresses

  ## IPv6
  enable_ipv6                                    = true
  public_subnet_assign_ipv6_address_on_creation  = true
  private_subnet_assign_ipv6_address_on_creation = true
  intra_subnet_assign_ipv6_address_on_creation   = true

  ## DNS64
  intra_subnet_enable_dns64                                     = false
  public_subnet_enable_dns64                                    = false
  private_subnet_enable_dns64                                   = false
  intra_subnet_enable_resource_name_dns_aaaa_record_on_launch   = false
  public_subnet_enable_resource_name_dns_aaaa_record_on_launch  = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  public_subnet_ipv6_prefixes  = [17, 18, 19] # 11, 12, 13 in hex
  private_subnet_ipv6_prefixes = [33, 34, 35] # 21, 22, 23 in hex
  intra_subnet_ipv6_prefixes   = [49, 50, 51] # 31, 32, 33 in hex

  ## tags
  public_route_table_tags = {
    Name = local.public_name
  }
  private_route_table_tags = {
    Name = local.private_name
  }
  intra_route_table_tags = {
    Name = local.intra_name
  }
  nat_eip_tags = {
    Name = var.name
  }
  nat_gateway_tags = {
    Name = var.name
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

## VPC Endpoint for S3. The type is Gateway, so it's free.
resource "aws_vpc_endpoint" "s3" {
  service_name    = "com.amazonaws.us-east-1.s3"
  vpc_id          = module.vpc.vpc_id
  route_table_ids = compact(concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids))
}
