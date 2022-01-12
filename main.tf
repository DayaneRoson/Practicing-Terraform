variable "users" {
  default = {
    jane : { country : "Germany", department : "DevOps" },
    mary : { country : "Australia", department : "ServiceDesk" },
    peter : { country : "Brazil", department : "Development" }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.70"
    }
  }
}

#Already configured the AWS credentials using environments variables
#Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

#Resources I want to alocate in the cloud
resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    "country"    = each.value.country
    "department" = each.value.department
  }
}