data "external" "organization" {
  program = ["sh", "-c", "aws organizations describe-organization --query Organization.'{id: Id, root: MasterAccountId}'"] 
}