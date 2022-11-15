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

data "external" "organization" {
  program = ["sh", "-c", "aws organizations describe-organization --query Organization.'{id: Id, root: MasterAccountId}'"] 
}

## S3 bucket policy for shared files for all AWS accounts in Organization
data "aws_iam_policy_document" "shared_rw_access_for_organization" {
  statement {
    sid = "Shared ReadWrite access for all AWS accounts in Organization"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}", "arn:aws:s3:::${aws_s3_bucket.this.id}/${var.shared_path}"]

    condition {
      test = "StringEquals"

      values = [
        data.external.organization.result["id"]
      ]

      variable = "aws:PrincipalOrgID"
    }

  }
}

## add S3 bucket policy
resource "aws_s3_bucket_policy" "shared_rw_access_for_organization" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.shared_rw_access_for_organization.json
}
