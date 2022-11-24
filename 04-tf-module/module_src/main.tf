provider "aws" {
  region = "eu-west-1"
}

variable "name" {
  type = string
  description = "Enter a name for the Unicorn"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloudformation_stack" "unicorn" {
  name = "unicorn-${var.name}"

  parameters = {
    UnicornName = var.name
  }

  template_body = <<STACK
{
  "Parameters" : {
    "UnicornName" : {
      "Type" : "String"
    }
  },
  "Resources" : {
    "Unicorn": {
      "Type" : "Custom::Unicorn",
      "Properties" : {
        "ServiceToken" : "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:CustomUnicornTracker",
        "UnicornName": { "Ref": "UnicornName" }
      }
    }
  }
}
STACK
}
