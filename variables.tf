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

variable "subnet_public_1_cidr_block" {
    default = "10.9.1.0/24"
}

variable "subnet_public_1_availability_zone" {
    default = "eu-central-1a"
}

variable "subnet_public_2_cidr_block" {
    default = "10.9.2.0/24"
}

variable "subnet_public_2_availability_zone" {
    default = "eu-central-1b"
}

variable "subnet_public_3_cidr_block" {
    default = "10.9.3.0/24"
}

variable "subnet_public_3_availability_zone" {
    default = "eu-central-1c"
}

variable "web1_key_name" {
    default = "key123"
}

variable "web2_key_name" {
    default = "key123"
}
