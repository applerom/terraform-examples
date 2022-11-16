## S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = var.name
}

## Block public access
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Enable versioning
resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

## Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_key_arn
    }
  }
}

## Force to disable ACL - it's worst practice to use ACL, use S3 bucket policies instead
resource "aws_s3_bucket_ownership_controls" "disable_acl" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

## DynamoDB table for the state lock
resource "aws_dynamodb_table" "this" {
  name           = coalesce(var.table_name, "${var.name}-lock")
  write_capacity = var.write_capacity
  read_capacity  = var.read_capacity
  hash_key       = var.hash_key

  attribute {
    name = var.attribute_name
    type = var.attribute_key
  }

}