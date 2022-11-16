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
  #  key            = "tf-backend.tfstate"
  #  region         = "us-east-1"
  #  encrypt        = "true"
  #}
}

provider "aws" {
  region  = var.region
}