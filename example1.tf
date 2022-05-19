resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = "true"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = var.subnet_public_1_cidr_block
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.subnet_public_1_availability_zone
    tags = {
        Name = "subnet-public-1"
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

resource "aws_route_table_association" "rta-public-subnet-1"{
    subnet_id = "${aws_subnet.subnet-public-1.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_security_group" "webserver" {
    vpc_id = "${aws_vpc.main.id}"
    name = "Webserver"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH port"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        ipv6_cidr_blocks = ["::/0"]
        description = "SSH port"
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP port"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description = "HTTP port"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS port"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description = "HTTPS port"
    }
    tags = {
        Name = "webserver"
    }
}

#resource "aws_instance" "web1" {
#    ami = "${lookup(var.AMI, var.AWS_Region)}"
#    instance_type = var.instance_type
#    # VPC
#    subnet_id = "${aws_subnet.subnet-public-1.id}"
#    # Security Group
#    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
#    # the Public SSH key
#    key_name = var.web1_key_name
#}
#
#resource "aws_instance" "web2" {
#    ami = "${lookup(var.AMI, var.AWS_Region)}"
#    instance_type = var.instance_type
#    # VPC
#    subnet_id = "${aws_subnet.subnet-public-1.id}"
#    # Security Group
#    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
#    # the Public SSH key
#    key_name = var.web2_key_name
#}
