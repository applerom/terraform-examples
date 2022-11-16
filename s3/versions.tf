terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  #backend "s3" {
  #  bucket         = "tf-state-myproject"
  #  dynamodb_table = "tf-state-myproject-lock"
  #  key            = "s3.tfstate"
  #  region         = "us-east-1"
  #  encrypt        = "true"
  #}
}

provider "aws" {
  region  = var.region
  #profile = "some-profile"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

#provider "aws" {
#  alias  = "dev"
#  profile = "dev"
#}
