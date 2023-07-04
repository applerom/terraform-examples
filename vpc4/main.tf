## get availability zones except very old in N.Virginia to avoid problems with EKS etc
data "aws_availability_zones" "azs" {
  state = "available"
  exclude_zone_ids = ["use1-az3"] # exclude the old zone without modern instances in the us-east-1
}

## VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  assign_generated_ipv6_cidr_block = true
}

## Public subnets
resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id = aws_vpc.this.id

  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 11)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index + 17)

  map_public_ip_on_launch         = true //it makes this a public subnet
  assign_ipv6_address_on_creation = true

  tags = {
      Name = "${var.name} ${var.public_suffix} ${upper(substr(data.aws_availability_zones.azs.names[count.index], -1, 1))}"
      #"kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
  }
}

## Private subnets
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id = aws_vpc.this.id

  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 21)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index + 33)

  assign_ipv6_address_on_creation = true

  tags = {
      Name = "${var.name} ${var.private_suffix} ${upper(substr(data.aws_availability_zones.azs.names[count.index], -1, 1))}"
      #"kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
  }
}

## Intra subnets
resource "aws_subnet" "intra" {
  count = var.az_count

  vpc_id = aws_vpc.this.id

  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 31)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index + 49)

  assign_ipv6_address_on_creation = true

  tags = {
      Name = "${var.name} ${var.intra_suffix} ${upper(substr(data.aws_availability_zones.azs.names[count.index], -1, 1))}"
  }
}

## Internet gateway
resource "aws_internet_gateway" "this" {
  depends_on = [aws_vpc.this]
  vpc_id = aws_vpc.this.id

  tags = {
      Name = var.name
  }
}

## Elastic IP for NAT Gateway
resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = var.name
  }
}

## NAT Gateway
resource "aws_nat_gateway" "this" {
  depends_on = [
    aws_internet_gateway.this,
    aws_eip.this,
  ]
  ## count         = var.nat_gw_count
  ## allocation_id = aws_eip.this[count.index].id
  ## subnet_id     = element(aws_subnet.public[*].id, count.index)
  ## use only one nat_gw
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.private[0].id

  tags = {
    #Name = "${var.name} ${count.index + 1}"
    Name = var.name
  }
}

## Egress only internet gateway for IPv6 private subnets
resource "aws_egress_only_internet_gateway" "this" {
  depends_on = [aws_vpc.this]
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

## Public route table with routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.this.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
      Name = "${var.name} ${var.public_suffix}"
  }
}

## Public route table assotiations
resource "aws_route_table_association" "public"{
  count = var.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

## Private route table with routes
resource "aws_route_table" "private" {
  depends_on = [aws_vpc.this]
  vpc_id = aws_vpc.this.id

  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_egress_only_internet_gateway.this.id
  }
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.this.id
  }

  tags = {
      Name = "${var.name} ${var.private_suffix}"
  }
}

## Private route table assotiations
resource "aws_route_table_association" "private"{
  count = var.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

## Intra route table with routes
resource "aws_route_table" "intra" {
  depends_on = [aws_vpc.this]
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "${var.name} ${var.intra_suffix}"
  }
}

## Intra route table assotiations
resource "aws_route_table_association" "intra"{
  count = var.az_count

  subnet_id      = aws_subnet.intra[count.index].id
  route_table_id = aws_route_table.intra.id
}

## VPC Endpoint for S3. Type - gateway so it's free.
resource "aws_vpc_endpoint" "s3" {
  service_name    = "com.amazonaws.${var.region}.s3"
  vpc_id          = aws_vpc.this.id
  route_table_ids = compact(concat(aws_route_table.private.*.id, aws_route_table.public.*.id))

  tags = {
      Name = "${var.name} S3"
  }
}

## VPC Endpoint for DynamoDB. Type - gateway so it's free.
resource "aws_vpc_endpoint" "dynamodb" {
  service_name    = "com.amazonaws.${var.region}.dynamodb"
  vpc_id          = aws_vpc.this.id
  route_table_ids = compact(concat(aws_route_table.private.*.id, aws_route_table.public.*.id))

  tags = {
      Name = "${var.name} DynamoDB"
  }
}
