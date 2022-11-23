# Terraform examples for basic AWS resources.

## Amazon S3

Using file my.tfvars:
```shell
tf apply -var-file my.tfvars
```
my.tfvars:
```hcl
name = "my-bucket" # ! change me !
#shared_path = "shared/*"
#accounts = ["012345678901","123456789010"]
sse_algorithm = "aws:kms"
kms_key_arn = "arn:aws:kms:us-east-1:012345678901:key/7054dbab-9415-4d07-9eef-2bed559fc162"
bucket_key_enabled = "true"
```


## AWS IAM

### Add trusted AWS accounts 012345678901 and 123456789010
```shell
tf apply -var accounts = ["012345678901","123456789010"]
```
Using terraform.tfvars:
```hcl
accounts = ["012345678901","123456789010"]
```

### Create state file
```shell
cp versions.tf state.tf
```
* Configure bucket and dynamodb_table to their own values.
* Uncomment and specify kms_key_id, if you have one, or you will only have SSL S3 encryption.
state.tf:
```hcl
terraform {
  backend "s3" {
    bucket         = "tf-state-my"
    dynamodb_table = "tf-state-my-lock"
    key            = "iam.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    #kms_key_id     = "arn:aws:kms:us-east-1:000000000000:key/00000000-0000-0000-0000-000000000000"
  }
}
```


## AWS KMS

### Add AWS accounts 012345678901 and 123456789010 to share this KMS
```shell
tf apply -var accounts = ["012345678901","123456789010"]
```
Using terraform.tfvars:
```hcl
accounts = ["012345678901","123456789010"]
```


## Global data configuration

### Add AWS accounts 012345678901 and 123456789010 to share this KMS
```shell
tf apply -var accounts={dev="012345678901"}
```
Using terraform.tfvars:
```hcl
accounts = {
    dev     = "012345678901"
    stage   = "123456789010"
}
```
