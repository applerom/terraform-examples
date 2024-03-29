data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "external" "organization" {
  program = ["sh", "-c", "aws organizations describe-organization --query Organization.'{id: Id, root: MasterAccountId}'"] 
}