provider "aws" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "unicorn" {
  source = "<paste output module URL of step 4>"

  name = "Andy"
}
