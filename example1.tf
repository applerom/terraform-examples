resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = "true"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet_public" {
    for_each = var.availability_zones

    vpc_id = "${aws_vpc.main.id}"

    availability_zone = each.key
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, each.value)
    ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.value + 6)

    map_public_ip_on_launch = "true" //it makes this a public subnet
    assign_ipv6_address_on_creation = true

    tags = {
        Name = "subnet-public-${each.value}"
    }
}

resource "aws_subnet" "subnet_private" {
    for_each = var.availability_zones

    vpc_id = "${aws_vpc.main.id}"

    availability_zone = each.key
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, each.value + 10)
    ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.value + 22)

    map_public_ip_on_launch = "true" //it makes this a public subnet
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "subnet-private-${each.value + 10}"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"
    tags = {
        Name = "igw"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.main.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    
    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "rta-public-subnet"{
#    count = length(aws_subnet.subnet_public)
    for_each = var.availability_zones

#    subnet_id = aws_subnet.subnet_public[count.index].id
    subnet_id = aws_subnet.subnet_public[each.key].id
    route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"
    tags = {
        Name = "igw"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.main.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    
    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "rta-public-subnet"{
#    count = length(aws_subnet.subnet_public)
    for_each = var.availability_zones

#    subnet_id = aws_subnet.subnet_public[count.index].id
    subnet_id = aws_subnet.subnet_public[each.key].id
    route_table_id = "${aws_route_table.public-rt.id}"
}
