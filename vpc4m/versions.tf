terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" { ## ↓↓↓ Check and change to actual values! ↓↓↓
    bucket         = "my-tf-state"
    dynamodb_table = "my-tf-state-lock"
    key            = "my/us-east-1/vpc.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    kms_key_id     = "arn:aws:kms:us-east-1:123456789012:key/e515a5c7-6736-584c-8999-66018a2fa9de"
  }
}

provider "aws" { ## ↓↓↓ Check and change to actual values! ↓↓↓
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/AWSDevOpsRole"
  }

  default_tags { ## ↓↓↓ Check and change to actual values! ↓↓↓
    tags = {
      env       = "test"
      terraform = "true"
    }
  }
}
