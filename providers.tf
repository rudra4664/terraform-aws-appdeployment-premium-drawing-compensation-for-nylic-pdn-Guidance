terraform {
  required_version = ">= 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

# tflint-ignore: terraform_unused_declarations
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = {
      appid = var.appid
    }
  }

  ignore_tags {
    keys = [
      "domain_join",
      "fqdn",
      "nyl:appid",
    ]

    key_prefixes = [
      "nyl:platform:",
    ]
  }
}
