variable "AMI" {
    type = map
    default = {
        eu-central-1 = "ami-07cd3675e7ca644fe"
        eu-north-1 = "ami-0adfc82c1ad9f327b"
    }
}

variable "AWS_Region" {
    default = "eu-central-1"
}

variable "instance_type" {
    default = "t4g.micro"
}

variable "vpc_cidr_block" {
    default = "10.9.0.0/16"
}

variable "public_subnets" { 
    default = {
        eu-central-1a = 11
        eu-central-1b = 12
        eu-central-1c = 13
    }
}

variable "private_subnets" { 
    default = {
        eu-central-1a = 21
        eu-central-1b = 22
        eu-central-1c = 23
    }
}

variable "web_key_name" {
    default = "key123"
}
