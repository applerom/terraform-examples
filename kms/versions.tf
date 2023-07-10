terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "my-tf-state"
    dynamodb_table = "my-tf-state-lock"
    key            = "devops/us-east-1/kms.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    kms_key_id     = "arn:aws:kms:us-east-1:345678901212:key/15a5c7e5-6736-8c45-8999-8a2fa9de6601"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      env       = "devops"
      terraform = "true"
    }
  }
}
