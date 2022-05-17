resource "aws_vpc" "main" {
  cidr_block       = "10.9.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.9.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-central-1a"
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
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "webserver"
    }
}