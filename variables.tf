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
