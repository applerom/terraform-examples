locals {
  alias = lower(replace(var.name, " ", "-"))
  accounts = [
    for account in var.accounts : format("arn:aws:iam::%s:root", account)
  ]
}

## KMS key
resource "aws_kms_key" "this" {
  description             = "${var.name} key"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.this.json
  #enable_key_rotation     = true
}

## KMS alias
resource "aws_kms_alias" "this" {
  name          = "alias/${local.alias}-key"
  target_key_id = aws_kms_key.this.key_id
}

## get current AWS account ID - data.aws_caller_identity.current.account_id
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  dynamic "statement" {
    for_each = length(local.accounts) > 0 ? [1] : []

    content {
      sid = "Allow use of the key"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = local.accounts
      }
    }
  }

  dynamic "statement" {
    for_each = length(local.accounts) > 0 ? [1] : []

    content {
      sid = "Allow attachment of persistent resources"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = local.accounts
      }

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = [true]
      }
    }
  }
}