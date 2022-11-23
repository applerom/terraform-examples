terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  #backend "s3" {
  #  bucket         = "tf-state-my"
  #  dynamodb_table = "tf-state-my-lock"
  #  key            = "org.tfstate"
  #  region         = "us-east-1"
  #  encrypt        = "true"
  ##  kms_key_id     = "arn:aws:kms:us-east-1:000000000000:key/00000000-0000-0000-0000-000000000000"
  #}
}

provider "aws" {
  region  = var.region
}